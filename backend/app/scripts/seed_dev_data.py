from datetime import datetime, timedelta, timezone

from sqlalchemy import select

from app.db.session import SessionLocal
from app.models.quiz import Quiz, QuizTopic


def seed() -> None:
    db = SessionLocal()

    try:
        existing_topic = db.scalar(select(QuizTopic).where(QuizTopic.id == "salvador-dali"))
        if existing_topic is None:
            db.add(
                QuizTopic(
                    id="salvador-dali",
                    type="artist",
                    title="Salvador Dali",
                    subtitle="Artist quiz",
                    description="Test your Salvador Dali knowledge.",
                    language="en",
                    is_featured=True,
                )
            )

        surrealism_topic = db.scalar(select(QuizTopic).where(QuizTopic.id == "surrealism"))
        if surrealism_topic is None:
            db.add(
                QuizTopic(
                    id="surrealism",
                    type="style",
                    title="Surrealism",
                    subtitle="Theme quiz",
                    description="Test your surrealism movement knowledge.",
                    language="en",
                    is_featured=True,
                )
            )

        daily_quiz = db.scalar(select(Quiz).where(Quiz.id == "daily-surrealism"))
        if daily_quiz is None:
            db.add(
                Quiz(
                    id="daily-surrealism",
                    topic_id="surrealism",
                    type="daily",
                    title="Quiz of the Day",
                    subtitle="Surrealism",
                    description="Daily quiz focused on surrealism.",
                    language="en",
                    difficulty="easy",
                    estimated_time_seconds=90,
                    question_count=1,
                    is_daily=True,
                    generated_at=datetime.now(timezone.utc),
                    expires_at=datetime.now(timezone.utc) + timedelta(days=1),
                    payload_json={
                        "id": "daily-surrealism",
                        "title": "Quiz of the Day",
                        "subtitle": "Surrealism",
                        "description": "Daily quiz focused on surrealism.",
                        "questions": [
                            {
                                "id": "q1",
                                "prompt": "Which artist is most closely associated with Surrealism?",
                                "kind": "singleChoice",
                                "options": [
                                    {"id": "a", "text": "Salvador Dali"},
                                    {"id": "b", "text": "Claude Monet"},
                                    {"id": "c", "text": "Ilya Repin"},
                                    {"id": "d", "text": "Edgar Degas"},
                                ],
                                "correct_option_id": "a",
                                "explanation": "Salvador Dali is one of the best-known Surrealist artists.",
                            }
                        ],
                    },
                )
            )

        artist_quiz = db.scalar(select(Quiz).where(Quiz.id == "artist-salvador-dali"))
        if artist_quiz is None:
            db.add(
                Quiz(
                    id="artist-salvador-dali",
                    topic_id="salvador-dali",
                    type="artist",
                    title="Salvador Dali",
                    subtitle="Artist quiz",
                    description="Test your Dali knowledge.",
                    language="en",
                    difficulty="easy",
                    estimated_time_seconds=75,
                    question_count=1,
                    is_daily=False,
                    generated_at=datetime.now(timezone.utc),
                    payload_json={
                        "id": "artist-salvador-dali",
                        "title": "Salvador Dali",
                        "subtitle": "Artist quiz",
                        "description": "Test your Dali knowledge.",
                        "questions": [
                            {
                                "id": "q1",
                                "prompt": "Which art style did Salvador Dali relate to most closely?",
                                "kind": "singleChoice",
                                "options": [
                                    {"id": "a", "text": "Surrealism"},
                                    {"id": "b", "text": "Impressionism"},
                                    {"id": "c", "text": "Realism"},
                                ],
                                "correct_option_id": "a",
                                "explanation": "Dali became one of the central figures of Surrealism.",
                            }
                        ],
                    },
                )
            )

        db.commit()
        print("Seed data inserted.")
    finally:
        db.close()


if __name__ == "__main__":
    seed()
