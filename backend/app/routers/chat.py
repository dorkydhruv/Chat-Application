import asyncio
import json
from fastapi import APIRouter, Depends, HTTPException,WebSocket, WebSocketDisconnect
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.database import get_db,Base
from app.models import Chats
from app.models import Messages
from app import schemas
from .video_connection_manager import VideoConnectionManager
from .connection_messenger import ConnectionMessenger
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
connection_messenger = ConnectionMessenger()
@router.websocket("/messages/{chat_id}")
async def message_Endpoint(websocket: WebSocket,chat_id=int,  db: Session = Depends(get_db)):
    await connection_messenger.connect(websocket)
    messages = db.query(Messages).filter(Messages.chatId==chat_id).all()

    for message in messages:
        payload = {
            "messageId":message.messageId,
            "chatId":message.chatId,
            "message":message.message,
            "userId":message.userId
        }
        print(payload)
        await websocket.send_json(payload)
        # await websocket.send_text(json.dumps(payload))
    try:
        while True:
            data = await websocket.receive_json()
            message = data
            '''
                data= {
                    "message": "Hello",
                    "userId" : 1,
                }
            '''
            #Save the message to the database
            m = Messages(chatId=chat_id,message=message["message"],userId=message["userId"])
            db.add(m)
            db.commit()
            db.refresh(m)
            payload = {
                "messageId":m.messageId,
                "chatId":m.chatId,
                "message":m.message,
                "userId":m.userId
            }
            await connection_messenger.broadcast(payload)
    except WebSocketDisconnect:
        id =await connection_messenger.disconnect(websocket)

#Send and accept candidates using websockets
video_connection_manager = VideoConnectionManager()
@router.websocket("/candidates/{chat_id}")
async def candidate_endpoint(websocket: WebSocket,chat_id:int):
    await video_connection_manager.connect(websocket,chat_id)
    try:
        while True:
            messageFromIceCandidate = await websocket.receive_json()
            if messageFromIceCandidate["type"] == "offer":
                await video_connection_manager.broadcast(chat_id,json.loads(messageFromIceCandidate["data"]))
            else:
                await video_connection_manager.send_message_to_initiator(chat_id,json.loads(messageFromIceCandidate["data"]))
    except WebSocketDisconnect:
        await video_connection_manager.disconnect(websocket,chat_id)

