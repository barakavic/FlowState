from fastapi import FastAPI
from app.api import endpoints

app = FastAPI(title="Flowstate API")

app.include_router(endpoints.router)

@app.get("/")
def read_root():
    return {"message": "Flowstate API is running"}
