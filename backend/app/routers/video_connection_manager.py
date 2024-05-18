from fastapi import WebSocket, WebSocketDisconnect
class VideoConnectionManager:
    def __init__(self)->None:
        self.active_rooms = {}
        self.initiators = {}
    
    async def connect(self,ws:WebSocket,room_id:int):
        await ws.accept()
        if room_id in self.active_rooms:
            self.active_rooms[room_id].add(ws)
        else:
            self.initiators[room_id] = ws
            self.active_rooms[room_id] = {ws}
    
    async def disconnect(self,ws:WebSocket,room_id:int):
        self.active_rooms[room_id].remove(ws)
        if len(self.active_rooms[room_id])==0:
            del self.active_rooms[room_id]
    
    async def broadcast(self,room_id:int,message:dict):
        if room_id in self.active_rooms:
            for ws in self.active_rooms[room_id]:
                if ws != self.initiators[room_id]:
                    await ws.send_json(message)
                         
    async def send_message_to_initiator(self,room_id:int,message:dict):
        await self.initiators[room_id].send_json(message)