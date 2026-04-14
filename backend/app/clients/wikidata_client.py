from __future__ import annotations

from dataclasses import dataclass

import httpx

from app.core.config import settings


@dataclass
class ArtistContext:
    entity_id: str
    name: str
    description: str | None
    birth_date: str | None
    death_date: str | None
    citizenship: str | None
    birth_place: str | None
    death_place: str | None
    occupations: list[str]
    movements: list[str]
    works: list[str]


class WikidataClient:
    base_url = "https://query.wikidata.org/sparql"

    def fetch_artist_context(self, entity_id: str) -> ArtistContext | None:
        query = self._artist_context_query(entity_id)

        with httpx.Client(timeout=30.0, headers={"User-Agent": settings.http_user_agent}) as client:
            response = client.get(
                self.base_url,
                params={"format": "json", "query": query},
                headers={"Accept": "application/sparql-results+json"},
            )
            response.raise_for_status()
            payload = response.json()

        bindings = payload.get("results", {}).get("bindings", [])
        if not bindings:
            return None

        binding = bindings[0]
        name = self._value(binding, "artistLabel")
        if not name:
            return None

        return ArtistContext(
            entity_id=entity_id,
            name=name,
            description=self._value(binding, "artistDescription"),
            birth_date=self._value(binding, "birthDate"),
            death_date=self._value(binding, "deathDate"),
            citizenship=self._value(binding, "citizenshipLabel"),
            birth_place=self._value(binding, "birthPlaceLabel"),
            death_place=self._value(binding, "deathPlaceLabel"),
            occupations=self._split_values(self._value(binding, "occupations")),
            movements=self._split_values(self._value(binding, "movements")),
            works=self._split_values(self._value(binding, "works")),
        )

    def _artist_context_query(self, entity_id: str) -> str:
        return f"""
        PREFIX bd: <http://www.bigdata.com/rdf#>
        PREFIX schema: <http://schema.org/>
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/>
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>

        SELECT ?artistLabel ?artistDescription ?birthDate ?deathDate ?citizenshipLabel ?birthPlaceLabel ?deathPlaceLabel
               (GROUP_CONCAT(DISTINCT ?occupationLabel; separator="||") AS ?occupations)
               (GROUP_CONCAT(DISTINCT ?movementLabel; separator="||") AS ?movements)
               (GROUP_CONCAT(DISTINCT ?workLabel; separator="||") AS ?works)
        WHERE {{
          BIND(wd:{entity_id} AS ?artist)

          OPTIONAL {{
            ?artist schema:description ?artistDescription.
            FILTER(LANG(?artistDescription) = "en")
          }}
          OPTIONAL {{ ?artist wdt:P569 ?birthDate. }}
          OPTIONAL {{ ?artist wdt:P570 ?deathDate. }}
          OPTIONAL {{ ?artist wdt:P27 ?citizenship. }}
          OPTIONAL {{ ?artist wdt:P19 ?birthPlace. }}
          OPTIONAL {{ ?artist wdt:P20 ?deathPlace. }}
          OPTIONAL {{ ?artist wdt:P106 ?occupation. }}
          OPTIONAL {{
            ?work wdt:P170 ?artist.
            OPTIONAL {{ ?work wdt:P135 ?movement. }}
          }}

          SERVICE wikibase:label {{
            bd:serviceParam wikibase:language "en".
          }}
        }}
        GROUP BY ?artistLabel ?artistDescription ?birthDate ?deathDate ?citizenshipLabel ?birthPlaceLabel ?deathPlaceLabel
        LIMIT 1
        """

    @staticmethod
    def _value(binding: dict, key: str) -> str | None:
        value = binding.get(key, {}).get("value")
        return value if isinstance(value, str) and value.strip() else None

    @staticmethod
    def _split_values(value: str | None) -> list[str]:
        if not value:
            return []

        return list(dict.fromkeys(part.strip() for part in value.split("||") if part.strip()))
