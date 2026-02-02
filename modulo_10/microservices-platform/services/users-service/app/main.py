from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from contextlib import asynccontextmanager
import logging
from redis import Redis
from pika import BlockingConnection, ConnectionParameters
from app.database import engine, Base, get_db
from app.routers import auth, users, profiles, admin
from app.config import settings
from app.middleware import LoggingMiddleware, RateLimitMiddleware

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/app.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Lifespan manager
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Gerencia eventos de startup e shutdown"""
    # Startup
    logger.info("Starting Users Service...")

    # Criar tabelas do banco
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables created/verified")

    # Conectar ao Redis
    try:
        app.state.redis = Redis(
            host=settings.REDIS_HOST,
            port=settings.REDIS_PORT,
            password=settings.REDIS_PASSWORD,
            decode_responses=True
        )
        app.state.redis.ping()
        logger.info("Redis connected successfully")
    except Exception as e:
        logger.error(f"Redis connection failed: {e}")
        app.state.redis = None

    # Conectar ao RabbitMQ
    try:
        connection = BlockingConnection(
            ConnectionParameters(
                host=settings.RABBITMQ_HOST,
                port=settings.RABBITMQ_PORT,
                credentials=settings.RABBITMQ_CREDENTIALS
            )
        )
        app.state.rabbitmq_channel = connection.channel()
        # Declarar exchange
        app.state.rabbitmq_channel.exchange_declare(
            exchange='user_events',
            exchange_type='topic',
            durable=True
        )
        logger.info("RabbitMQ connected successfully")
    except Exception as e:
        logger.error(f"RabbitMQ connection failed: {e}")
        app.state.rabbitmq_channel = None

    yield

    # Shutdown
    logger.info("Shutting down Users Service...")
    if hasattr(app.state, 'redis') and app.state.redis:
        app.state.redis.close()
    if hasattr(app.state, 'rabbitmq_channel') and app.state.rabbitmq_channel:
        app.state.rabbitmq_channel.close()

# Criar aplicação FastAPI
app = FastAPI(
    title="Users Service API",
    description="Microserviço de gerenciamento de usuários",
    version="1.0.0",
    lifespan=lifespan
)

# Middlewares
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(TrustedHostMiddleware, allowed_hosts=settings.ALLOWED_HOSTS)
app.add_middleware(LoggingMiddleware)
app.add_middleware(RateLimitMiddleware, calls=100, period=60)

# Rotas de health check
@app.get("/health", status_code=status.HTTP_200_OK)
async def health_check():
    """Endpoint de health check"""
    health_status = {
        "status": "healthy",
        "service": "users-service",
        "version": "1.0.0",
        "database": "connected",
        "redis": "connected" if app.state.redis else "disconnected",
        "rabbitmq": "connected" if app.state.rabbitmq_channel else "disconnected"
    }
    return health_status

@app.get("/", include_in_schema=False)
async def root():
    """Página inicial"""
    return {
        "message": "Users Service API",
        "docs": "/docs",
        "health": "/health"
    }

# Registrar rotas
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/users", tags=["Users"])
app.include_router(profiles.router, prefix="/profiles", tags=["Profiles"])
app.include_router(admin.router, prefix="/admin", tags=["Administration"])

# Handler de erros
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    logger.error(f"HTTPException: {exc.detail}")
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail},
    )

@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"},
    )