from datetime import datetime, timedelta, timezone

import httpx
from sqlalchemy.orm import Session

from app.clients.wikidata_client import WikidataClient
from app.models.quiz import Quiz, QuizTopic
from app.repositories.quiz_repository import QuizRepository
from app.schemas.quiz import QuizListItem, QuizPayload, QuizResponse, TopicResponse
from app.services.artist_quiz_generation_service import ArtistQuizGenerationService


class QuizService:
    minimum_artist_question_count = 5

    def __init__(self, db: Session) -> None:
        self.repository = QuizRepository(db)
        self.wikidata_client = WikidataClient()
        self.artist_quiz_generation_service = ArtistQuizGenerationService()

    def list_topics(self) -> list[TopicResponse]:
        topics = self.repository.list_topics()
        return [TopicResponse.model_validate(topic) for topic in topics]

    def list_quizzes(self) -> list[QuizListItem]:
        quizzes = self.repository.list_quizzes()
        return [QuizListItem.model_validate(quiz) for quiz in quizzes]

    def get_daily_quiz(self) -> QuizResponse | None:
        quiz = self.repository.get_daily_quiz()
        return self._map_quiz(quiz) if quiz else None

    def get_artist_quiz(self, artist_id: str) -> QuizResponse | None:
        quiz = self.repository.get_artist_quiz(artist_id)
        if quiz and self._is_sufficient_artist_quiz(quiz):
            return self._map_quiz(quiz)

        if not self._looks_like_entity_id(artist_id):
            return None

        try:
            context = self.wikidata_client.fetch_artist_context(artist_id)
        except httpx.HTTPError:
            return None

        if context is None:
            return None

        generated_quiz = self.artist_quiz_generation_service.build_quiz(context)
        payload = self.artist_quiz_generation_service.build_payload(artist_id, generated_quiz)

        topic = self.repository.get_topic(artist_id)
        if topic is None:
            topic = self.repository.save_topic(
                QuizTopic(
                    id=artist_id,
                    type="artist",
                    title=context.name,
                    subtitle="Artist quiz",
                    description=f"Test your {context.name} knowledge.",
                    language="en",
                    is_featured=False,
                )
            )

        now = datetime.now(timezone.utc)
        stored_quiz = self.repository.save_quiz(
            Quiz(
                id=f"artist-{artist_id}",
                topic_id=topic.id,
                type="artist",
                title=generated_quiz.title,
                subtitle=generated_quiz.subtitle,
                description=generated_quiz.description,
                language="en",
                difficulty="easy",
                estimated_time_seconds=generated_quiz.estimated_time_seconds,
                question_count=len(generated_quiz.questions),
                is_daily=False,
                generated_at=now,
                expires_at=now + timedelta(hours=168),
                payload_json=payload.model_dump(),
            )
        )

        return self._map_quiz(stored_quiz)

    def _map_quiz(self, quiz) -> QuizResponse:
        payload = QuizPayload.model_validate(quiz.payload_json)
        return QuizResponse(
            id=quiz.id,
            topic_id=quiz.topic_id,
            type=quiz.type,
            title=quiz.title,
            subtitle=quiz.subtitle,
            description=quiz.description,
            language=quiz.language,
            difficulty=quiz.difficulty,
            estimated_time_seconds=quiz.estimated_time_seconds,
            question_count=quiz.question_count,
            is_daily=quiz.is_daily,
            payload=payload,
        )

    @staticmethod
    def _looks_like_entity_id(artist_id: str) -> bool:
        return artist_id.startswith("Q") and artist_id[1:].isdigit()

    def _is_sufficient_artist_quiz(self, quiz: Quiz) -> bool:
        if quiz.expires_at and quiz.expires_at < datetime.now(timezone.utc):
            return False

        return quiz.question_count >= self.minimum_artist_question_count
