from pydantic import BaseModel, ConfigDict


class QuizOption(BaseModel):
    id: str
    text: str


class QuizQuestion(BaseModel):
    id: str
    prompt: str
    kind: str
    options: list[QuizOption]
    correct_option_id: str
    explanation: str


class QuizPayload(BaseModel):
    id: str
    title: str
    subtitle: str | None = None
    description: str | None = None
    questions: list[QuizQuestion]


class TopicResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    type: str
    title: str
    subtitle: str | None = None
    description: str | None = None
    language: str
    is_featured: bool


class QuizListItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    topic_id: str
    type: str
    title: str
    subtitle: str | None = None
    description: str | None = None
    difficulty: str
    estimated_time_seconds: int
    question_count: int
    is_daily: bool


class QuizResponse(BaseModel):
    id: str
    topic_id: str
    type: str
    title: str
    subtitle: str | None = None
    description: str | None = None
    language: str
    difficulty: str
    estimated_time_seconds: int
    question_count: int
    is_daily: bool
    payload: QuizPayload
