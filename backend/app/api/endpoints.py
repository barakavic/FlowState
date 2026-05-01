from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from sqlmodel import Session, select
from typing import List, Optional
from datetime import datetime, timezone

from app.database import get_session
from app.models import ExecutionUnit, Step, User
from app.schemas import (
    ExecutionUnitCreate, ExecutionUnitUpdate, ExecutionUnitResponse,
    StepCreate, StepUpdate, StepResponse, FocusUpdate,
    ScheduleRequest, PressureResponse
)
from app.services.scheduler import schedule_unit
from app.services.pressure import get_system_pressure
from app.services.parser_md import parse_markdown_roadmap
from app.services.parser_pdf import parse_pdf_toc

router = APIRouter()

def utc_now() -> datetime:
    return datetime.now(timezone.utc)

# Mock Auth Dependency
def get_current_user_id(session: Session = Depends(get_session)) -> int:
    user = session.exec(select(User).where(User.id == 1)).first()
    if not user:
        user = User(email="test@example.com")
        session.add(user)
        session.commit()
        session.refresh(user)
    return user.id

def enforce_active_limits(session: Session, user_id: int, new_unit_type: str = None):
    active_units = session.exec(select(ExecutionUnit).where(
        ExecutionUnit.user_id == user_id, 
        ExecutionUnit.status == "active"
    )).all()
    
    if len(active_units) >= 5:
        raise HTTPException(status_code=400, detail="Max 5 active units allowed")
    
    if new_unit_type == "course":
        pass
    elif new_unit_type == "book":
        books_count = sum(1 for u in active_units if u.type == "book")
        if books_count >= 2:
            raise HTTPException(status_code=400, detail="Max 2 active books allowed")


@router.get("/units", response_model=List[ExecutionUnitResponse])
def get_units(session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    return session.exec(select(ExecutionUnit).where(ExecutionUnit.user_id == user_id)).all()

@router.post("/units", response_model=ExecutionUnitResponse)
def create_unit(unit_in: ExecutionUnitCreate, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    enforce_active_limits(session, user_id, unit_in.type)
    
    unit = ExecutionUnit(**unit_in.dict(), user_id=user_id)
    session.add(unit)
    session.commit()
    session.refresh(unit)
    return unit

@router.put("/units/{unit_id}", response_model=ExecutionUnitResponse)
def update_unit(unit_id: int, unit_in: ExecutionUnitUpdate, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    unit = session.get(ExecutionUnit, unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Unit not found")
        
    if unit_in.status == "active" and unit.status != "active":
        # Check limits before making active
        enforce_active_limits(session, user_id, unit.type)

    update_data = unit_in.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(unit, key, value)
    
    unit.updated_at = utc_now()
    session.add(unit)
    session.commit()
    session.refresh(unit)
    return unit

@router.delete("/units/{unit_id}")
def delete_unit(unit_id: int, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    unit = session.get(ExecutionUnit, unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Unit not found")
        
    # Focus Safety: Clear focus if this unit is deleted
    user = session.get(User, user_id)
    if user and user.current_focus_unit_id == unit_id:
        user.current_focus_unit_id = None
        session.add(user)

    session.delete(unit)
    session.commit()
    return {"ok": True}

@router.get("/units/{unit_id}/steps", response_model=List[StepResponse])
def get_steps(unit_id: int, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    unit = session.get(ExecutionUnit, unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Unit not found")
    # Always sort by order_index ASC
    steps = session.exec(select(Step).where(Step.execution_unit_id == unit_id).order_by(Step.order_index.asc())).all()
    return steps

@router.post("/units/{unit_id}/steps", response_model=StepResponse)
def create_step(unit_id: int, step_in: StepCreate, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    unit = session.get(ExecutionUnit, unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Unit not found")
        
    step = Step(**step_in.dict(), execution_unit_id=unit_id)
    session.add(step)
    session.commit()
    session.refresh(step)
    return step

@router.put("/steps/{step_id}", response_model=StepResponse)
def update_step(step_id: int, step_in: StepUpdate, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    step = session.get(Step, step_id)
    if not step:
        raise HTTPException(status_code=404, detail="Step not found")
    unit = session.get(ExecutionUnit, step.execution_unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Step not found")
        
    update_data = step_in.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(step, key, value)
    
    step.updated_at = utc_now()
    
    # Activity tracking
    unit.last_activity_at = utc_now()
    
    session.add(step)
    session.add(unit)
    session.commit()
    session.refresh(step)
    return step

@router.post("/steps/{step_id}/complete")
def complete_step(step_id: int, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    step = session.get(Step, step_id)
    if not step:
        raise HTTPException(status_code=404, detail="Step not found")
    unit = session.get(ExecutionUnit, step.execution_unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Step not found")
        
    # Enforce course sequencing
    if unit.type == "course":
        prev_step = session.exec(select(Step).where(
            Step.execution_unit_id == unit.id,
            Step.order_index < step.order_index
        ).order_by(Step.order_index.desc())).first()
        
        if prev_step and prev_step.status != "done":
            raise HTTPException(status_code=400, detail="Previous step must be completed first")

    step.status = "done"
    step.completed_at = utc_now()
    step.updated_at = utc_now()
    unit.last_activity_at = utc_now()
    
    session.add(step)
    
    # Check if all steps completed
    all_steps = session.exec(select(Step).where(Step.execution_unit_id == unit.id)).all()
    # Replace the current step in the list evaluation since we haven't committed yet
    if all((s.status == "done" if s.id != step.id else True) for s in all_steps):
        unit.status = "completed"
        
        # Focus Safety: Clear focus if unit is completed
        user = session.get(User, user_id)
        if user and user.current_focus_unit_id == unit.id:
            user.current_focus_unit_id = None
            session.add(user)
            
    session.add(unit)
    session.commit()
    return {"ok": True}

@router.get("/focus")
def get_focus(session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    user = session.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"current_focus_unit_id": user.current_focus_unit_id}

@router.post("/focus/{unit_id}")
def set_focus(unit_id: int, session: Session = Depends(get_session), user_id: int = Depends(get_current_user_id)):
    user = session.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    unit = session.get(ExecutionUnit, unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Unit not found")
        
    user.current_focus_unit_id = unit_id
    user.updated_at = utc_now()
    
    # Activity tracking
    unit.last_activity_at = utc_now()
    
    session.add(user)
    session.add(unit)
    session.commit()
    return {"ok": True, "current_focus_unit_id": unit_id}

@router.post("/units/{unit_id}/schedule", response_model=ExecutionUnitResponse)
def schedule_execution_unit(
    unit_id: int, 
    request: ScheduleRequest, 
    session: Session = Depends(get_session), 
    user_id: int = Depends(get_current_user_id)
):
    # Verify ownership
    unit = session.get(ExecutionUnit, unit_id)
    if not unit or unit.user_id != user_id:
        raise HTTPException(status_code=404, detail="Unit not found")
        
    return schedule_unit(
        session=session,
        unit_id=unit_id,
        duration=request.duration,
        duration_unit=request.duration_unit,
        hours_per_day=request.hours_per_day
    )

@router.get("/system/pressure", response_model=PressureResponse)
def get_pressure(
    session: Session = Depends(get_session), 
    user_id: int = Depends(get_current_user_id)
):
    return get_system_pressure(session, user_id)

@router.post("/parse/roadmap")
async def parse_roadmap(
    title: Optional[str] = Form(None),
    unit_id: Optional[int] = Form(None),
    file: Optional[UploadFile] = File(None),
    text: Optional[str] = Form(None),
    session: Session = Depends(get_session),
    user_id: int = Depends(get_current_user_id)
):
    content = ""
    if file:
        content = (await file.read()).decode("utf-8")
    elif text:
        content = text
    else:
        raise HTTPException(status_code=400, detail="Either file or text must be provided")

    return parse_markdown_roadmap(
        session=session,
        content=content,
        user_id=user_id,
        title=title,
        unit_id=unit_id
    )

@router.post("/parse/pdf")
async def parse_pdf(
    file: UploadFile = File(...),
    title: Optional[str] = Form(None),
    unit_id: Optional[int] = Form(None),
    session: Session = Depends(get_session),
    user_id: int = Depends(get_current_user_id)
):
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are supported")

    file_bytes = await file.read()
    
    return parse_pdf_toc(
        session=session,
        file_bytes=file_bytes,
        user_id=user_id,
        title=title,
        unit_id=unit_id
    )
