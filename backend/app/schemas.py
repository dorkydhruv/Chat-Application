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

# class UserLogin(BaseModel):
#     email: EmailStr
#     password: str