"""create quiz tables

Revision ID: 20260413_000001
Revises:
Create Date: 2026-04-13 14:35:00
"""

from alembic import op
import sqlalchemy as sa


revision = "20260413_000001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "quiz_topics",
        sa.Column("id", sa.String(length=64), primary_key=True),
        sa.Column("type", sa.String(length=32), nullable=False),
        sa.Column("title", sa.String(length=255), nullable=False),
        sa.Column("subtitle", sa.String(length=255), nullable=True),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("language", sa.String(length=8), nullable=False, server_default="en"),
        sa.Column("is_featured", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )

    op.create_table(
        "quizzes",
        sa.Column("id", sa.String(length=64), primary_key=True),
        sa.Column("topic_id", sa.String(length=64), sa.ForeignKey("quiz_topics.id"), nullable=False),
        sa.Column("type", sa.String(length=32), nullable=False),
        sa.Column("title", sa.String(length=255), nullable=False),
        sa.Column("subtitle", sa.String(length=255), nullable=True),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("language", sa.String(length=8), nullable=False, server_default="en"),
        sa.Column("difficulty", sa.String(length=16), nullable=False, server_default="easy"),
        sa.Column("estimated_time_seconds", sa.Integer(), nullable=False, server_default="60"),
        sa.Column("question_count", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("is_daily", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("generated_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("payload_json", sa.JSON(), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )

    op.create_index("ix_quizzes_topic_id", "quizzes", ["topic_id"])
    op.create_index("ix_quizzes_is_daily", "quizzes", ["is_daily"])


def downgrade() -> None:
    op.drop_index("ix_quizzes_is_daily", table_name="quizzes")
    op.drop_index("ix_quizzes_topic_id", table_name="quizzes")
    op.drop_table("quizzes")
    op.drop_table("quiz_topics")
