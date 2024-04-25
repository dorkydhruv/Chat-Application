from sqlalchemy import Column,Integer,String,ForeignKey
from .database import Base
from sqlalchemy.sql.sqltypes import TIMESTAMP
from sqlalchemy.sql.expression import text
from sqlalchemy.orm import relationship



class Chats(Base):
    __tablename__ = "chats"
    chatId = Column(Integer,primary_key=True,index=True)
    user1_id = Column(Integer,ForeignKey('users.userId',ondelete="CASCADE"),nullable=False)
    user2_id = Column(Integer,ForeignKey('users.userId',ondelete="CASCADE"),nullable=False)
    user1 = relationship("Users",foreign_keys=[user1_id])
    user2 = relationship("Users",foreign_keys=[user2_id])

class Messages(Base):
    __tablename__ = "messages"
    messageId = Column(Integer,primary_key=True,index=True)
    chatId = Column(Integer,nullable=False)
    userId = Column(Integer,ForeignKey("users.userId",ondelete="CASCADE"),nullable=False)
    message = Column(String,nullable=False)
    createdAt = Column(TIMESTAMP(timezone=True),server_default=text("now()"),nullable=False)
    user = relationship("Users",foreign_keys=[userId])


class Users(Base):
    __tablename__ = "users"
    userId = Column(Integer,primary_key=True,index=True)
    email = Column(String,unique=True,index=True,nullable=False)
    password = Column(String,nullable=False)
    displayName = Column(String,nullable=False)
    createdAt = Column(TIMESTAMP(timezone=True),server_default=text("now()"),nullable=False)