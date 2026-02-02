from pydantic import BaseModel, EmailStr, Field, validator
from typing import Optional, List
from datetime import datetime
from uuid import UUID
import re

# Schemas base
class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = Field(None, min_length=2, max_length=255)

class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=100)

    @validator('password')
    def validate_password(cls, v):
        if not re.search(r'[A-Z]', v):
            raise ValueError('Password must contain at least one uppercase letter')
        if not re.search(r'[a-z]', v):
            raise ValueError('Password must contain at least one lowercase letter')
        if not re.search(r'\d', v):
            raise ValueError('Password must contain at least one digit')
        if not re.search(r'[!@#$%^&*(),.?":{}|<>]', v):
            raise ValueError('Password must contain at least one special character')
        return v

class UserUpdate(BaseModel):
    full_name: Optional[str] = Field(None, min_length=2, max_length=255)
    is_active: Optional[bool] = None

class UserInDB(UserBase):
    id: UUID
    is_active: bool
    is_admin: bool
    is_verified: bool
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True

class UserResponse(UserInDB):
    pass

class ProfileBase(BaseModel):
    bio: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[dict] = None

class ProfileCreate(ProfileBase):
    pass

class ProfileUpdate(ProfileBase):
    pass

class ProfileResponse(ProfileBase):
    id: UUID
    user_id: UUID
    avatar_url: Optional[str]
    settings: dict
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True

# Auth schemas
class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int

class TokenData(BaseModel):
    user_id: Optional[UUID] = None
    email: Optional[str] = None

# Pagination
class PaginationParams(BaseModel):
    page: int = Field(1, ge=1)
    per_page: int = Field(10, ge=1, le=100)

class PaginatedResponse(BaseModel):
    items: List
    total: int
    page: int
    per_page: int
    total_pages: int