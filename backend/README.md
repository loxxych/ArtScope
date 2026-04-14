# ArtScope Backend

FastAPI backend for quiz generation and delivery.

## Stack

- Python 3.12+
- FastAPI
- PostgreSQL
- SQLAlchemy
- Alembic
- Pydantic Settings

## Quick Start

1. Create a virtual environment and install dependencies.
2. Copy `.env.example` to `.env`.
3. Start PostgreSQL and create a database.
4. Run migrations.
5. Start the server.

Example commands:

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
cp .env.example .env
alembic upgrade head
uvicorn app.main:app --reload
```

## Initial Endpoints

- `GET /health`
- `GET /api/v1/quizzes/topics`
- `GET /api/v1/quizzes/daily`
- `GET /api/v1/quizzes/artist/{artist_id}`

## Notes

- Quiz content is English-only for now.
- User attempts are expected to stay on device for the first milestone.
- Quiz generation is not implemented yet; current responses come from seeded placeholders or cache misses.
