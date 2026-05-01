from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel

class StepCreate(BaseModel):
    title: str
    order_index: int
    weight: float = 1.0
    allocated_hours: float
    deadline: Optional[datetime] = None

class StepUpdate(BaseModel):
    title: Optional[str] = None
    weight: Optional[float] = None
    allocated_hours: Optional[float] = None
    deadline: Optional[datetime] = None

class StepResponse(BaseModel):
    id: int
    execution_unit_id: int
    title: str
    order_index: int
    weight: float
    allocated_hours: float
    deadline: Optional[datetime]
    status: str
    created_at: datetime
    updated_at: datetime

class ExecutionUnitCreate(BaseModel):
    title: str
    type: str
    total_hours: float
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None

class ExecutionUnitUpdate(BaseModel):
    title: Optional[str] = None
    status: Optional[str] = None
    total_hours: Optional[float] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None

class ExecutionUnitResponse(BaseModel):
    id: int
    title: str
    type: str
    total_hours: float
    start_date: Optional[datetime]
    end_date: Optional[datetime]
    status: str
    last_activity_at: datetime
    user_id: int
    created_at: datetime
    updated_at: datetime

class FocusUpdate(BaseModel):
    unit_id: Optional[int] = None

class ScheduleRequest(BaseModel):
    duration: int
    duration_unit: str # "days" | "weeks"
    hours_per_day: float

class PressureResponse(BaseModel):
    overdue_steps: int
    stale_units: int
    no_progress_today: bool
