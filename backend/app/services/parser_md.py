from typing import Optional
from fastapi import HTTPException
from sqlmodel import Session, select
from app.models import ExecutionUnit, Step

def parse_markdown_roadmap(
    session: Session,
    content: str,
    user_id: int,
    title: Optional[str] = None,
    unit_id: Optional[int] = None
):
    if not title and not unit_id:
        raise HTTPException(status_code=400, detail="Either title or unit_id must be provided")

    # 1. Get or Create ExecutionUnit
    if unit_id:
        unit = session.get(ExecutionUnit, unit_id)
        if not unit or unit.user_id != user_id:
            raise HTTPException(status_code=404, detail="Execution Unit not found")
    else:
        unit = ExecutionUnit(
            title=title,
            type="project",
            status="backlog",
            total_hours=0.0,
            user_id=user_id
        )
        session.add(unit)
        session.commit()
        session.refresh(unit)

    # 2. Parse content
    steps_to_create = []
    lines = content.splitlines()
    order_index = 1
    
    # We ignore mileston titles in storage for now as per requirement (Steps are flat)
    # But order is maintained
    for line in lines:
        line = line.strip()
        if line.startswith("- ") or line.startswith("* "):
            step_title = line[2:].strip()
            if step_title:
                step = Step(
                    execution_unit_id=unit.id,
                    title=step_title,
                    order_index=order_index,
                    weight=1.0,
                    allocated_hours=0.0,
                    status="pending"
                )
                steps_to_create.append(step)
                order_index += 1

    if not steps_to_create:
        # If we created a unit but found no steps, we should probably delete it or error
        # Requirement says return 400 if no valid steps found
        if not unit_id:
            session.delete(unit)
            session.commit()
        raise HTTPException(status_code=400, detail="No valid steps found in roadmap")

    # 3. Persist steps
    for step in steps_to_create:
        session.add(step)
    
    session.commit()
    
    return {
        "unit_id": unit.id,
        "number_of_steps": len(steps_to_create)
    }
