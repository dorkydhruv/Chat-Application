import asyncio
from fastapi import APIRouter, Depends, HTTPException,WebSocket
from sqlalchemy.orm import Session
from app.database import get_db,Base
from app.models import Chats
from app.models import Messages
from app import schemas
router = APIRouter(
    prefix="/chat",
    tags=["chat"],
)

@router.post("/create")
def create_chat(chat:schemas.ChatCreate,db:Session=Depends(get_db)):
    db.add(chat)
    db.commit()
    db.refresh(chat)
    return chat

@router.get("/get/{user}")
def get_chats(user:int,db:Session=Depends(get_db)):
    chats = db.query(Chats).filter(Chats.user1==user or Chats.user2==user).all()
    return chats

@router.websocket("/ws/get-messages/{chat}")
async def message_Endpoint(websocket: WebSocket, chat: int, db: Session = Depends(get_db)):
    await websocket.accept()
    while True:
        messages = db.query(Messages).filter(Messages.chatId == chat).all()
        for message in messages:
            await websocket.send_text(str(message))
        await asyncio.sleep(1)

@router.post("/send-message")
def send_message(chat:int,user:int,message:str,db:Session=Depends(get_db)):
    msg = Messages(chatId=chat,userId=user,message=message)
    db.add(msg)
    db.commit()
    db.refresh(msg)
    return msg
