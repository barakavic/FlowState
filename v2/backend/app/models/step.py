from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy import DateTime, String, Integer, DECIMAL, ForeignKey
from app.database import Base
import uuid
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import UUID
from app.models.status import Status
from app.models.task import Task

class Step(Base):
    __tablename__ = "steps"
    stepid: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    steptitle: Mapped[str] = mapped_column(String)
    orderidx: Mapped[int] = mapped_column(Integer)
    orderstatus: Mapped[Status] = mapped_column(String, default=Status.TODO)
    createdAt: Mapped[DateTime] = mapped_column(DateTime(timezone=True), onupdate=func.now(), server_default=func.now(), nullable=False)
    allocatedHours: Mapped[DECIMAL] = mapped_column(DECIMAL(10,3), nullable=False)
    deadline: Mapped[DateTime] = mapped_column(DateTime(timezone=True), onupdate=func.now(), server_default=func.now(), nullable=False)
    completedAt: Mapped[DateTime] = mapped_column(DateTime(timezone=True))
    taskID: Mapped[int] = mapped_column(ForeignKey("tasks.tasksid", ondelete="CASCADE"), nullable=False)
    tasks: Mapped[Task] = relationship("Task", back_populates="steps")

    