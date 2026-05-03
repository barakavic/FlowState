from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Integer, ForeignKey, Numeric, Boolean, DateTime, UUID
from app.database import Base
from app.models.status import Status
from datetime import datetime
from sqlalchemy.sql import func
from app.models.task_type import TaskType
from app.models.user import User
from uuid import UUID


class Task(Base):
    __tablename__ = "tasks"
    tasksid: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True, unique=True)
    name: Mapped[str] = mapped_column(String(50), nullable=False)
    descr: Mapped[str] = mapped_column(String, nullable=True)
    status: Mapped[Status] = mapped_column(
        String(20),
        default=Status.TODO
    )
    created_at: Mapped[datetime] = mapped_column( 
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now(),nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        onupdate=func.now(),
        server_default=func.now(),
        nullable=False
        )
    deadline: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        onupdate=func.now(),
        server_default=func.now(),
        nullable=True
        )
    typeId: Mapped[int] = mapped_column(ForeignKey("tasktype.taskid", ondelete="CASCADE"), nullable=False)
    task_type: Mapped[TaskType] = relationship("TaskType", back_populates="tasks")

    userId: Mapped[UUID] = mapped_column(ForeignKey("users.userid", ondelete="CASCADE"), nullable=False)
    user: Mapped[User] = relationship("User", back_populates="tasks")



    
                                                 