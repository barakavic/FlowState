from datetime import datetime, timezone, timedelta
from sqlmodel import Session, select, func
from app.models import ExecutionUnit, Step

def get_system_pressure(session: Session, user_id: int):
    now = datetime.now(timezone.utc)
    
    # Base query for active units
    active_units_query = select(ExecutionUnit).where(
        ExecutionUnit.user_id == user_id,
        ExecutionUnit.status == "active"
    )
    active_units = session.exec(active_units_query).all()
    active_unit_ids = [u.id for u in active_units]

    if not active_unit_ids:
        return {
            "overdue_steps": 0,
            "stale_units": 0,
            "no_progress_today": True
        }

    # 1. Overdue Steps (only in active units)
    overdue_steps_count = session.exec(
        select(func.count(Step.id)).where(
            Step.execution_unit_id.in_(active_unit_ids),
            Step.status != "done",
            Step.deadline < now
        )
    ).one()

    # 2. Stale Units
    stale_threshold = now - timedelta(hours=48)
    stale_units_count = session.exec(
        select(func.count(ExecutionUnit.id)).where(
            ExecutionUnit.user_id == user_id,
            ExecutionUnit.status == "active",
            ExecutionUnit.last_activity_at < stale_threshold
        )
    ).one()

    # 3. No Progress Today
    # Get the start of the current UTC day
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    
    progress_today_exists = session.exec(
        select(Step).where(
            Step.execution_unit_id.in_(active_unit_ids),
            Step.status == "done",
            Step.completed_at >= today_start
        )
    ).first()

    return {
        "overdue_steps": overdue_steps_count,
        "stale_units": stale_units_count,
        "no_progress_today": progress_today_exists is None
    }
