from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.quiz import Quiz, QuizTopic


class QuizRepository:
    def __init__(self, db: Session) -> None:
        self.db = db

    def list_topics(self) -> list[QuizTopic]:
        stmt = select(QuizTopic).order_by(QuizTopic.is_featured.desc(), QuizTopic.title.asc())
        return list(self.db.scalars(stmt).all())

    def list_quizzes(self) -> list[Quiz]:
        stmt = select(Quiz).order_by(Quiz.is_daily.desc(), Quiz.created_at.desc())
        return list(self.db.scalars(stmt).all())

    def get_daily_quiz(self) -> Quiz | None:
        stmt = select(Quiz).where(Quiz.is_daily.is_(True)).order_by(Quiz.created_at.desc())
        return self.db.scalars(stmt).first()

    def get_artist_quiz(self, artist_id: str) -> Quiz | None:
        stmt = (
            select(Quiz)
            .join(QuizTopic, Quiz.topic_id == QuizTopic.id)
            .where(QuizTopic.id == artist_id, QuizTopic.type == "artist")
            .order_by(Quiz.created_at.desc())
        )
        return self.db.scalars(stmt).first()

    def get_topic(self, topic_id: str) -> QuizTopic | None:
        stmt = select(QuizTopic).where(QuizTopic.id == topic_id)
        return self.db.scalars(stmt).first()

    def save_topic(self, topic: QuizTopic) -> QuizTopic:
        self.db.add(topic)
        self.db.flush()
        return topic

    def save_quiz(self, quiz: Quiz) -> Quiz:
        self.db.add(quiz)
        self.db.commit()
        self.db.refresh(quiz)
        return quiz
