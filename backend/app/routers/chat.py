import asyncio
from fastapi import APIRouter, Depends, HTTPException,WebSocket, WebSocketDisconnect
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.database import get_db,Base
from app.models import Chats
from app.models import Messages
from app import schemas
from .connection_messenger import ConnectionMessenger
router = APIRouter(
    prefix="/chat",
    tags=["chat"],
)
connection_messenger = ConnectionMessenger()
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
@router.websocket("/messages/{chat}")
async def message_Endpoint(websocket: WebSocket, chat: int, db: Session = Depends(get_db)):

    await connection_messenger.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await connection_messenger.broadcast(data)
    except WebSocketDisconnect:
        id =await connection_messenger.disconnect(websocket)
        await connection_messenger.broadcast({"type":"disconnect","id":id})


