from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from app import schemas, models, crud, security
from app.database import get_db
from app.config import settings
from app.utils import send_email, publish_event
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

@router.post("/register", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED)
async def register(
    user_data: schemas.UserCreate,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db)
):
    """Registrar novo usuário"""
    # Verificar se email já existe
    existing_user = crud.get_user_by_email(db, user_data.email)
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Criar usuário
    user = crud.create_user(db, user_data)

    # Publicar evento
    if hasattr(router.app.state, 'rabbitmq_channel') and router.app.state.rabbitmq_channel:
        background_tasks.add_task(
            publish_event,
            router.app.state.rabbitmq_channel,
            'user.registered',
            {
                'user_id': str(user.id),
                'email': user.email,
                'timestamp': datetime.utcnow().isoformat()
            }
        )

    # Enviar email de verificação (em background)
    background_tasks.add_task(
        send_email,
        user.email,
        "Welcome to our platform!",
        f"Please verify your email address. Your user ID is {user.id}"
    )

    return user

@router.post("/login", response_model=schemas.TokenResponse)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    """Login de usuário"""
    user = crud.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is disabled"
        )

    # Criar tokens
    access_token = security.create_access_token(data={"sub": str(user.id)})
    refresh_token = security.create_refresh_token(data={"sub": str(user.id)})

    # Atualizar último login
    user.last_login = datetime.utcnow()
    db.commit()

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer",
        "expires_in": settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
    }

@router.post("/refresh", response_model=schemas.TokenResponse)
async def refresh_token(
    refresh_token: str,
    db: Session = Depends(get_db)
):
    """Refresh access token"""
    try:
        payload = security.verify_token(refresh_token)
        user_id = payload.get("sub")

        user = crud.get_user(db, user_id)
        if not user or not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )

        # Criar novo access token
        access_token = security.create_access_token(data={"sub": str(user.id)})

        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "bearer",
            "expires_in": settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token"
        )

@router.post("/logout")
async def logout(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    """Logout - invalidar token"""
    # Na implementação real, adicionaria o token a uma blacklist
    # Aqui apenas retornamos sucesso
    return {"message": "Successfully logged out"}