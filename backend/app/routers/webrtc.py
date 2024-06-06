import socketio

sio = socketio.AsyncServer(cors_allowed_origins='*',async_mode='asgi')
socket_app = socketio.ASGIApp(sio)

@sio.event
async def connect(sid, environ):
    print("connect ", sid)



@sio.event
async def disconnect(sid):
    print("disconnect ", sid)