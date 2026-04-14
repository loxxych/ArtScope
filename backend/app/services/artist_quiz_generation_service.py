from __future__ import annotations

from dataclasses import dataclass
from random import Random

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
    fallback_places = [
        "Paris", "Madrid", "Florence", "Vienna", "Amsterdam", "Barcelona", "Rome", "Milan"
    ]
    fallback_movements = [
        "Impressionism", "Cubism", "Baroque", "Romanticism", "Expressionism", "Realism", "Symbolism"
    ]
    fallback_occupations = [
        "Painter", "Illustrator", "Sculptor", "Printmaker", "Engraver", "Muralist", "Draftsman"
    ]
    fallback_work_titles = [
        "The Starry Night", "Impression, Sunrise", "The Night Watch", "Guernica",
        "The Persistence of Memory", "The Scream", "Girl with a Pearl Earring"
    ]
    fallback_citizenships = [
        "French", "Spanish", "Italian", "Dutch", "Austrian", "German", "Russian", "British"
    ]
    fallback_descriptions = [
        "Visual artist", "Painter and illustrator", "Sculptor and engraver", "Modern artist"
    ]

    def build_quiz(self, context: ArtistContext) -> GeneratedArtistQuiz:
        rng = Random(context.entity_id)
        questions: list[QuizQuestion] = []

        movement = context.movements[0] if context.movements else None
        if movement:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Which artistic movement is most closely linked with {context.name}?",
                    correct_answer=movement,
                    distractors=self._distractors(
                        correct_answer=movement,
                        preferred=context.movements[1:],
                        fallback=self.fallback_movements,
                        rng=rng,
                    ),
                    explanation=f"{context.name} is associated with {movement} in the source data.",
                )
            )

        if context.birth_place:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Where was {context.name} born?",
                    correct_answer=context.birth_place,
                    distractors=self._distractors(
                        correct_answer=context.birth_place,
                        preferred=[context.death_place] if context.death_place else [],
                        fallback=self.fallback_places,
                        rng=rng,
                    ),
                    explanation=f"The available artist data lists {context.birth_place} as the place of birth.",
                )
            )

        if context.citizenship:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"What nationality is associated with {context.name}?",
                    correct_answer=context.citizenship,
                    distractors=self._distractors(
                        correct_answer=context.citizenship,
                        preferred=[],
                        fallback=self.fallback_citizenships,
                        rng=rng,
                    ),
                    explanation=f"{context.citizenship} is listed as the citizenship for {context.name}.",
                )
            )

        if context.works:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Which artwork is associated with {context.name}?",
                    correct_answer=context.works[0],
                    distractors=self._distractors(
                        correct_answer=context.works[0],
                        preferred=context.works[1:],
                        fallback=self.fallback_work_titles,
                        rng=rng,
                    ),
                    explanation=f"{context.works[0]} appears among the works linked to {context.name}.",
                )
            )

        if context.occupations:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Which occupation is listed for {context.name}?",
                    correct_answer=context.occupations[0],
                    distractors=self._distractors(
                        correct_answer=context.occupations[0],
                        preferred=context.occupations[1:],
                        fallback=self.fallback_occupations,
                        rng=rng,
                    ),
                    explanation=f"{context.occupations[0]} is listed among the occupations for {context.name}.",
                )
            )

        birth_year = self._extract_year(context.birth_date)
        death_year = self._extract_year(context.death_date)
        if birth_year:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"In which year was {context.name} born?",
                    correct_answer=birth_year,
                    distractors=self._year_distractors(
                        correct_year=birth_year,
                        secondary_year=death_year,
                        rng=rng,
                    ),
                    explanation=f"The source data lists {birth_year} as the birth year of {context.name}.",
                )
            )

        description = self._normalized_description(context.description)
        if description:
            questions.append(
                self._single_choice_question(
                    question_id=f"q{len(questions) + 1}",
                    prompt=f"Which description best matches {context.name}?",
                    correct_answer=description,
                    distractors=self._distractors(
                        correct_answer=description,
                        preferred=[],
                        fallback=self.fallback_descriptions,
                        rng=rng,
                    ),
                    explanation="This answer was built from the artist description returned by Wikidata.",
                )
            )

        if not questions:
            questions.append(
                self._single_choice_question(
                    question_id="q1",
                    prompt=f"Which occupation best matches {context.name}?",
                    correct_answer="Painter",
                    distractors=["Composer", "Actor", "Writer", "Lawyer"],
                    explanation="This answer was built from the artist description returned by Wikidata.",
                )
            )

        deduplicated_questions = self._deduplicate_questions(questions)

        return GeneratedArtistQuiz(
            title=context.name,
            subtitle="Artist quiz",
            description=f"Test your {context.name} knowledge.",
            estimated_time_seconds=max(90, min(180, len(deduplicated_questions) * 25)),
            questions=deduplicated_questions[:5],
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

    def _distractors(
        self,
        correct_answer: str,
        preferred: list[str],
        fallback: list[str],
        rng: Random,
    ) -> list[str]:
        pool: list[str] = []

        for value in preferred + fallback:
            if not value:
                continue
            if value.lower() == correct_answer.lower():
                continue
            if value not in pool:
                pool.append(value)

        rng.shuffle(pool)
        return pool

    def _year_distractors(
        self,
        correct_year: str,
        secondary_year: str | None,
        rng: Random,
    ) -> list[str]:
        candidates: list[str] = []

        if secondary_year and secondary_year != correct_year:
            candidates.append(secondary_year)

        try:
            year_value = int(correct_year)
        except ValueError:
            return ["1850", "1900", "1950"]

        for offset in (-20, -10, 10, 20, 30):
            candidate = str(year_value + offset)
            if candidate != correct_year and candidate not in candidates:
                candidates.append(candidate)

        rng.shuffle(candidates)
        return candidates

    def _extract_year(self, raw_value: str | None) -> str | None:
        if not raw_value:
            return None

        normalized = raw_value.removeprefix("+")
        if len(normalized) < 4:
            return None

        year = normalized[:4]
        return year if year.isdigit() else None

    def _normalized_description(self, description: str | None) -> str | None:
        if not description:
            return None

        normalized = description.strip()
        return normalized[:1].upper() + normalized[1:] if normalized else None

    def _deduplicate_questions(self, questions: list[QuizQuestion]) -> list[QuizQuestion]:
        seen_prompts: set[str] = set()
        result: list[QuizQuestion] = []

        for question in questions:
            if question.prompt in seen_prompts:
                continue
            seen_prompts.add(question.prompt)
            result.append(question)

        return result
