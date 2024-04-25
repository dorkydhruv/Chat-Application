from sqlalchemy import Column,Integer,String
from .database import Base
from sqlalchemy.sql.sqltypes import TIMESTAMP
from sqlalchemy.sql.expression import text

class Users(Base):
    __tablename__ = "users"
    userId = Column(Integer,primary_key=True,index=True)
    email = Column(String,unique=True,index=True,nullable=False)
    password = Column(String,nullable=False)
    displayName = Column(String,nullable=False)
    createdAt = Column(TIMESTAMP(timezone=True),server_default=text("now()"),nullable=False)

class Chats(Base):
    __tablename__ = "chats"
    chatId = Column(Integer,primary_key=True,index=True)
    user1 = Column(Integer,nullable=False)
    user2 = Column(Integer,nullable=False)

class Messages(Base):
    __tablename__ = "messages"
    messageId = Column(Integer,primary_key=True,index=True)
    chatId = Column(Integer,nullable=False)
    userId = Column(Integer,nullable=False)
    message = Column(String,nullable=False)
    createdAt = Column(TIMESTAMP(timezone=True),server_default=text("now()"),nullable=False)