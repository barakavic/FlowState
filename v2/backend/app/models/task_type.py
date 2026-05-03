from sqlalchemy import String, Integer, DateTime
from sqlalchemy.orm import Relationship, Mapped, mapped_column
from datetime import datetime
from enum import Enum
from app.database import Base
from app.models.type import Type

class TaskType(Base):
    __tablename__ = "tasktype"
    taskid: Mapped[int] = mapped_column(Integer, autoincrement=True, primary_key=True, unique=True, nullable=False)
    type: Mapped[Type] = mapped_column(String(20), default=Type.PROJECT)


