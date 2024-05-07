import datetime
from pydantic import BaseModel, EmailStr

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    displayName: str

class UserOut(BaseModel):
    userId:int
    email: str
    displayName: str
    createdAt: datetime.datetime
    class Config:
        from_attributes = True

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class ChatCreate(BaseModel):
    user1_id:int
    user2_id:int

class ChatOut(BaseModel):
    chatId: int
    user1: UserOut
    user2: UserOut
    class Config:
        from_attributes = True
