from fastapi import Depends, FastAPI, WebSocket,status
from fastapi.responses import HTMLResponse
from .database import engine, Base,get_db
from sqlalchemy.orm import Session
from . import schemas
from . import models
app = FastAPI()


@app.get("/")
async def get():
    return {"message": "Wassup?"}

# models.Base.metadata.create_all(bind=engine)
@app.post("/users",status_code=status.HTTP_201_CREATED,response_model=schemas.UserOut)
async def create_user(user:schemas.UserCreate,db:Session=Depends(get_db)):
    new_user = models.Users(**user.dict())
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"User sent: {data}")