from datetime import timedelta, datetime, timezone
from fastapi import HTTPException
from sqlmodel import Session, select
from app.models import ExecutionUnit, Step

def schedule_unit(
    session: Session, 
    unit_id: int, 
    duration: int, 
    duration_unit: str, 
    hours_per_day: float
):
    unit = session.get(ExecutionUnit, unit_id)
    if not unit:
        raise HTTPException(status_code=404, detail="Execution Unit not found")

    steps = sorted(unit.steps, key=lambda s: s.order_index)
    if not steps:
        raise HTTPException(status_code=400, detail="Unit has no steps to schedule")

    total_weight = sum(step.weight for step in steps)
    if total_weight == 0:
        raise HTTPException(status_code=400, detail="Total step weight cannot be zero")

    # 1. Calculate total hours
    if duration_unit == "weeks":
        total_hours = duration * 7 * hours_per_day
    elif duration_unit == "days":
        total_hours = duration * hours_per_day
    else:
        raise HTTPException(status_code=400, detail="Invalid duration unit")

    # 2. Distribute hours and calculate cumulative deadlines
    # Start from unit start_date or now if not set
    current_time = unit.start_date or datetime.now(timezone.utc)
    if not unit.start_date:
        unit.start_date = current_time

    for step in steps:
        allocated_hours = total_hours * (step.weight / total_weight)
        step.allocated_hours = allocated_hours
        
        # Convert hours to timedelta
        step_duration = timedelta(hours=allocated_hours)
        deadline = current_time + step_duration
        
        step.deadline = deadline
        current_time = deadline
        
        session.add(step)

    # 3. Update unit
    unit.total_hours = total_hours
    unit.end_date = current_time # Last step deadline
    
    session.add(unit)
    session.commit()
    session.refresh(unit)
    
    return unit
