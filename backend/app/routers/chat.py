import asyncio
from fastapi import APIRouter, Depends, HTTPException,WebSocket
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.database import get_db,Base
from app.models import Chats
from app.models import Messages
from app import schemas
from ..oauth import get_current_user
router = APIRouter(
    prefix="/chat",
    tags=["chat"],
)

#Create Chat
@router.post("/create")
def create_chat(chat:schemas.ChatCreate,db:Session=Depends(get_db)):
    chat = Chats(user1=chat.user1,user2=chat.user2)
    db.add(chat)
    db.commit()
    db.refresh(chat)
    return chat

#Get all chats where user is part of
@router.get("/get/{user}")
def get_chats(user:int,db:Session=Depends(get_db)):
    chats = db.query(Chats).filter(or_(Chats.user1==user,Chats.user2==user)).all()
    return chats

#Get messages of the particular chat
#Should work on this again.
@router.websocket("/messages/{chat}/{userId}")
async def message_Endpoint(websocket: WebSocket, chat: int,userId:int, db: Session = Depends(get_db)):
    await websocket.accept()
    messages = db.query(Messages).filter(Messages.chatId == chat).all()
    for message in messages:
                await websocket.send_text(f"{message.userId}: {message.message}")
    try:
        while True:
            data = await websocket.receive_text()
            message = Messages(chatId=chat, userId=userId, message=data)
            db.add(message)
            db.commit()
            db.refresh(message)
            await websocket.send_text(f"{message.userId}: {message.message}")
    except:
        pass
    
