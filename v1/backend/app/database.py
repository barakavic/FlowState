import os
from sqlmodel import create_engine, Session

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://flowstate_user:flowstate_password@localhost:5432/flowstate_db")

engine = create_engine(DATABASE_URL)

def get_session():
    with Session(engine) as session:
        yield session
