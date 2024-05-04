from fastapi import WebSocket, WebSocketDisconnect, FastAPI
from dataclasses import dataclass
import uuid
import json

class ConnectionMessenger:
    def __init__(self) -> None:
        self.active_connections = {}
    
    async def connect(self,ws:WebSocket):
        await ws.accept()
        connection_id = str(uuid.uuid4())
        self.active_connections[connection_id] = ws

        await self.send_message_to(ws,json.dumps({"type":"connect","id":id}))
    
    async def disconnect(self,ws:WebSocket):
        connection_id = self.find_connection_id(ws)
        print(connection_id + " disconnected")
        del self.active_connections[connection_id]
        return connection_id

    
    def find_connection_id(self,ws:WebSocket):
        for connection_id,connection in self.active_connections.items():
            if connection == ws:
                return connection_id
        return None
    
    async def send_message_to(self,ws: WebSocket,message: str):
        await ws.send_text(message)
    
    async def broadcast(self,message:str):
        for connection in self.active_connections.values():
            await connection.send_text(message)