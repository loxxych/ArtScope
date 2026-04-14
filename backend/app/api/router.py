from fastapi import APIRouter

from app.api.routes import quizzes


api_router = APIRouter()
api_router.include_router(quizzes.router, prefix="/quizzes", tags=["quizzes"])
