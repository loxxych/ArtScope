from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.schemas.quiz import QuizListItem, QuizResponse, TopicResponse
from app.services.quiz_service import QuizService


router = APIRouter()


@router.get("/topics", response_model=list[TopicResponse])
def list_topics(db: Session = Depends(get_db)) -> list[TopicResponse]:
    service = QuizService(db)
    return service.list_topics()


@router.get("/daily", response_model=QuizResponse)
def get_daily_quiz(db: Session = Depends(get_db)) -> QuizResponse:
    service = QuizService(db)
    quiz = service.get_daily_quiz()
    if quiz is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Daily quiz is not available yet.",
        )
    return quiz


@router.get("/artist/{artist_id}", response_model=QuizResponse)
def get_artist_quiz(artist_id: str, db: Session = Depends(get_db)) -> QuizResponse:
    service = QuizService(db)
    quiz = service.get_artist_quiz(artist_id)
    if quiz is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Quiz for artist '{artist_id}' was not found.",
        )
    return quiz


@router.get("", response_model=list[QuizListItem])
def list_quizzes(db: Session = Depends(get_db)) -> list[QuizListItem]:
    service = QuizService(db)
    return service.list_quizzes()
