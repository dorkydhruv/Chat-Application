from fastapi import Depends, FastAPI, WebSocket,status,HTTPException
from fastapi.middleware.cors import CORSMiddleware
from .database import engine, Base,get_db
from sqlalchemy.orm import Session
from . import schemas
from . import models
from . import utils
from . import oauth
from .routers import chat
app = FastAPI()
# Create all tables
Base.metadata.create_all(bind=engine)
# Include routers
app.include_router(chat.router)
#include origins and cors policies
origins=[
    "*",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

@app.get("/")
async def get():
    return {"message": "Wassup?"}

@app.post("/users",status_code=status.HTTP_201_CREATED,response_model=schemas.UserOut)
async def create_user(user:schemas.UserCreate,db:Session=Depends(get_db)):
    user.password = utils.hashed(user.password)
    new_user = models.Users(**user.dict())
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.post("/login",status_code=status.HTTP_200_OK)
async def login(user:schemas.UserLogin,db:Session=Depends(get_db)):
    db_user = db.query(models.Users).where(models.Users.email==user.email).first()
    if db_user is None:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,detail="No such user")
    if utils.verify_password(user.password,db_user.password):
        data = {
            "userId":db_user.userId,
        }
        return {"access_token":oauth.create_access_token(data),"token_type":"bearer"}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,detail="Invalid auth")

@app.get("/search",status_code=status.HTTP_200_OK,response_model=list[schemas.UserOut])
async def search(name:str="",db:Session=Depends(get_db)):
    users = db.query(models.Users).where(models.Users.displayName.like(f"%{name}%")).all()
    return users

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"User sent: {data}")

@app.get("/check-access")
def test(user: schemas.UserOut = Depends(oauth.get_current_user)):
    print(user)
    return user


