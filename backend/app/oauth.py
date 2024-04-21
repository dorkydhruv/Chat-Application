from jose import JWTError,jwt
import datetime
from sqlalchemy.orm import Session
from .import models,schemas
from app.database import get_db
from fastapi import Depends,HTTPException,status
from fastapi.security import OAuth2PasswordBearer
oauth_scheme = OAuth2PasswordBearer(tokenUrl="login")
SECRET_KEY = "ccfc857affe6ae6ca3c6d38610813ec3"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1440

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.datetime.utcnow() + datetime.timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp":expire})
    encoded_jwt = jwt.encode(to_encode,SECRET_KEY,algorithm=ALGORITHM)
    return encoded_jwt

def decode_access_token(token: str):
    try:
        payload = jwt.decode(token,SECRET_KEY,algorithms=[ALGORITHM])
        return payload
    except JWTError:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,detail="Invalid token")
    
def get_current_user(token: str = Depends(oauth_scheme),db: Session = Depends(get_db)):
    payload = decode_access_token(token)
    user = db.query(models.Users).where(models.Users.userId==payload.get("userId")).first()
    if user is None:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,detail="No such user")
    return schemas.UserOut(userId=user.userId,email=user.email,displayName=user.displayName,createdAt=user.createdAt)