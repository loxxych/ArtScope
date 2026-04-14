from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    app_name: str = "ArtScope Backend"
    app_env: str = "development"
    app_debug: bool = True
    api_v1_prefix: str = "/api/v1"
    database_url: str = "postgresql+psycopg://postgres:postgres@localhost:5432/artscope"
    openai_api_key: str = ""
    quiz_language: str = "en"
    quiz_cache_ttl_hours: int = 168
    http_user_agent: str = "ArtScope Backend/0.1 (quiz generation service)"


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
