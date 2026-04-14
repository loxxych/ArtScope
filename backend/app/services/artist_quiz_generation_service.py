from __future__ import annotations

from dataclasses import dataclass

from app.clients.wikidata_client import ArtistContext
from app.schemas.quiz import QuizOption, QuizPayload, QuizQuestion


@dataclass(frozen=True)
class GeneratedArtistQuiz:
    title: str
    subtitle: str
    description: str
    estimated_time_seconds: int
    questions: list[QuizQuestion]


class ArtistQuizGenerationService:
    fallback_places = ["Paris", "Madrid", "Florence", "Vienna", "Amsterdam"]
    fallback_movements = ["Impressionism", "Cubism", "Baroque", "Romanticism", "Expressionism"]
    fallback_occupations = ["Painter", "Illustrator", "Sculptor", "Printmaker", "Engraver"]
    fallback_work_titles = ["The Starry Night", "Impression, Sunrise", "The Night Watch", "Guernica"]

    def build_quiz(self, context: ArtistContext) -> GeneratedArtistQuiz:
        questions: list[QuizQuestion] = []

        movement = context.movements[0] if context.movements else None
        if movement:
            questions.append(
                self._single_choice_question(
                    question_id="q1",
                    prompt=f"Which artistic movement is most closely linked with {context.name}?",
                    correct_answer=movement,
                    distractors=self.fallback_movements,
                    explanation=f"{context.name} is associated with {movement} in the source data.",
                )
            )

        if context.birth_place:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Where was {context.name} born?",
                    correct_answer=context.birth_place,
                    distractors=self.fallback_places,
                    explanation=f"The available artist data lists {context.birth_place} as the place of birth.",
                )
            )

        if context.works:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Which artwork is associated with {context.name}?",
                    correct_answer=context.works[0],
                    distractors=self.fallback_work_titles,
                    explanation=f"{context.works[0]} appears among the works linked to {context.name}.",
                )
            )

        if len(questions) < 3 and context.occupations:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Which occupation is listed for {context.name}?",
                    correct_answer=context.occupations[0],
                    distractors=self.fallback_occupations,
                    explanation=f"{context.occupations[0]} is listed among the occupations for {context.name}.",
                )
            )

        if not questions:
            questions.append(
                self._single_choice_question(
                    question_id="q1",
                    prompt=f"Which description best matches {context.name}?",
                    correct_answer=context.description or "Visual artist",
                    distractors=["Composer", "Actor", "Writer", "Lawyer"],
                    explanation="This answer was built from the artist description returned by Wikidata.",
                )
            )

        return GeneratedArtistQuiz(
            title=context.name,
            subtitle="Artist quiz",
            description=f"Test your {context.name} knowledge.",
            estimated_time_seconds=max(60, len(questions) * 25),
            questions=questions[:3],
        )

    def build_payload(self, topic_id: str, quiz: GeneratedArtistQuiz) -> QuizPayload:
        return QuizPayload(
            id=f"artist-{topic_id}",
            title=quiz.title,
            subtitle=quiz.subtitle,
            description=quiz.description,
            questions=quiz.questions,
        )

    def _single_choice_question(
        self,
        question_id: str,
        prompt: str,
        correct_answer: str,
        distractors: list[str],
        explanation: str,
    ) -> QuizQuestion:
        unique_answers = [correct_answer]
        for distractor in distractors:
            if distractor.lower() != correct_answer.lower() and distractor not in unique_answers:
                unique_answers.append(distractor)
            if len(unique_answers) == 4:
                break

        options = [
            QuizOption(id=option_id, text=answer)
            for option_id, answer in zip(["a", "b", "c", "d"], unique_answers, strict=False)
        ]
        correct_option = next(option for option in options if option.text == correct_answer)

        return QuizQuestion(
            id=question_id,
            prompt=prompt,
            kind="singleChoice",
            options=options,
            correct_option_id=correct_option.id,
            explanation=explanation,
        )
