import asyncio
from fastapi import APIRouter, Depends, HTTPException,WebSocket
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.database import get_db,Base
from app.models import Chats
from app.models import Messages
from app import schemas
router = APIRouter(
    prefix="/chat",
    tags=["chat"],
)

#Create Chat
@router.post("/create",response_model=schemas.ChatOut)
def create_chat(chat:schemas.ChatCreate,db:Session=Depends(get_db)):
    existing_chat = db.query(Chats).filter(or_(Chats.user1_id==chat.user1_id,Chats.user2_id==chat.user1_id)).first()
    if existing_chat:
        return existing_chat
    chat = Chats(user1_id=chat.user1_id,user2_id=chat.user2_id)
    db.add(chat)
    db.commit()
    db.refresh(chat)
    return chat

#Get all chats where user is part of
@router.get("/get/{user_id}",response_model=list[schemas.ChatOut])
def get_chats(user_id:int,db:Session=Depends(get_db)):
    chats = db.query(Chats).filter(or_(Chats.user1_id==user_id,Chats.user2_id==user_id)).all()
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


