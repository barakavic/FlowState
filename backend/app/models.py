from datetime import datetime, timezone
from typing import Optional, List
from sqlmodel import SQLModel, Field, Relationship, UniqueConstraint
from sqlalchemy import CheckConstraint

def utc_now() -> datetime:
    return datetime.now(timezone.utc)

class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True)
    current_focus_unit_id: Optional[int] = Field(default=None, foreign_key="executionunit.id")
    created_at: datetime = Field(default_factory=utc_now)
    updated_at: datetime = Field(default_factory=utc_now)

    execution_units: List["ExecutionUnit"] = Relationship(
        back_populates="user",
        sa_relationship_kwargs={"foreign_keys": "[ExecutionUnit.user_id]"}
    )

class ExecutionUnit(SQLModel, table=True):
    __table_args__ = (
        CheckConstraint("status IN ('backlog', 'active', 'completed')", name="check_unit_status"),
    )
    id: Optional[int] = Field(default=None, primary_key=True)
    title: str
    type: str # project | book | course
    total_hours: float
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    status: str = Field(default="active", index=True) # active | backlog | completed
    last_activity_at: datetime = Field(default_factory=utc_now, index=True)
    user_id: int = Field(foreign_key="user.id", index=True)
    created_at: datetime = Field(default_factory=utc_now)
    updated_at: datetime = Field(default_factory=utc_now)

    user: Optional[User] = Relationship(
        back_populates="execution_units",
        sa_relationship_kwargs={"foreign_keys": "[ExecutionUnit.user_id]"}
    )
    steps: List["Step"] = Relationship(back_populates="execution_unit")

class Step(SQLModel, table=True):
    __table_args__ = (
        UniqueConstraint("execution_unit_id", "order_index"),
        CheckConstraint("status IN ('pending', 'done')", name="check_step_status"),
        CheckConstraint(
            "(status = 'done' AND completed_at IS NOT NULL) OR (status != 'done' AND completed_at IS NULL)",
            name="check_step_completion"
        ),
    )
    id: Optional[int] = Field(default=None, primary_key=True)
    execution_unit_id: int = Field(foreign_key="executionunit.id", index=True)
    title: str
    order_index: int
    weight: float = Field(default=1.0)
    allocated_hours: float
    deadline: Optional[datetime] = Field(default=None, index=True)
    status: str = Field(default="pending", index=True) # pending | done
    completed_at: Optional[datetime] = Field(default=None, index=True)
    created_at: datetime = Field(default_factory=utc_now)
    updated_at: datetime = Field(default_factory=utc_now)

    execution_unit: Optional[ExecutionUnit] = Relationship(back_populates="steps")
