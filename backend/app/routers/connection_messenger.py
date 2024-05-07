from fastapi import WebSocket, WebSocketDisconnect, FastAPI
from dataclasses import dataclass
import uuid
import json

class ConnectionMessenger:
    def __init__(self) -> None:
        self.active_connections = set()
    
    async def connect(self,ws:WebSocket):
        await ws.accept()
        self.active_connections.add(ws)
    
    async def disconnect(self,ws:WebSocket):
        self.active_connections.remove(ws)

    
    async def send_message_to(self,ws: WebSocket,message: dict):
        await ws.send_json(message)
    
    async def broadcast(self,message:dict):

        
        for ws in self.active_connections:
            await ws.send_json(message)