//
//  Endpoints.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

enum WikidataEndpoint {
    static let baseURL = URL(string: "https://query.wikidata.org")!
    private static let userAgent = "ArtScope/1.0 (educational iOS app)"
    private static let requestTimeout: TimeInterval = 30

    static func artist(by name: String) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("sparql"),
            resolvingAgainstBaseURL: false
        )!

        components.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "query", value: /* SPARQL query */ "")
        ]

        return URLRequest(url: components.url!)
    }
    
    static func artistsList(limit: Int) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("sparql"),
            resolvingAgainstBaseURL: false
        )!

        let query = """
        PREFIX bd: <http://www.bigdata.com/rdf#>
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/>
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>

        SELECT DISTINCT ?artist ?artistLabel ?artistDescription ?image WHERE {
          ?artist wdt:P31 wd:Q5;
                  wdt:P106 ?occupation;
                  wdt:P18 ?image.
          
          ?occupation wdt:P279* wd:Q3391743.

          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en".
          }
        }
        LIMIT \(limit)
        """

        components.queryItems = [
            .init(name: "format", value: "json"),
            .init(name: "query", value: query)
        ]

        var request = URLRequest(url: components.url!)
        request.timeoutInterval = requestTimeout
        request.setValue("application/sparql-results+json", forHTTPHeaderField: "Accept")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
    
    static func artistDetails(entityID: String) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("sparql"),
            resolvingAgainstBaseURL: false
        )!
        
        let query = """
        PREFIX bd: <http://www.bigdata.com/rdf#>
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/>
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>

        SELECT ?artistLabel ?artistDescription ?birthName ?birthDate ?deathDate ?citizenshipLabel ?birthPlaceLabel ?deathPlaceLabel
               (GROUP_CONCAT(DISTINCT ?occupationLabel; separator=", ") AS ?occupations)
        WHERE {
          BIND(wd:\(entityID) AS ?artist)
          OPTIONAL { ?artist wdt:P1477 ?birthName. FILTER(LANG(?birthName) = "en") }
          OPTIONAL { ?artist wdt:P569 ?birthDate. }
          OPTIONAL { ?artist wdt:P570 ?deathDate. }
          OPTIONAL { ?artist wdt:P27 ?citizenship. }
          OPTIONAL { ?artist wdt:P19 ?birthPlace. }
          OPTIONAL { ?artist wdt:P20 ?deathPlace. }
          OPTIONAL { ?artist wdt:P106 ?occupation. }

          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en".
          }
        }
        GROUP BY ?artistLabel ?artistDescription ?birthName ?birthDate ?deathDate ?citizenshipLabel ?birthPlaceLabel ?deathPlaceLabel
        LIMIT 1
        """
        
        return makeRequest(components: components, query: query)
    }
    
    static func artistWorks(entityID: String, limit: Int) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("sparql"),
            resolvingAgainstBaseURL: false
        )!
        
        let query = """
        PREFIX bd: <http://www.bigdata.com/rdf#>
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/>
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>

        SELECT DISTINCT ?work ?workLabel ?image WHERE {
          ?work wdt:P170 wd:\(entityID);
                wdt:P18 ?image.
          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en".
          }
        }
        LIMIT \(limit)
        """
        
        return makeRequest(components: components, query: query)
    }
    
    private static func makeRequest(components: URLComponents, query: String) -> URLRequest {
        var components = components
        components.queryItems = [
            .init(name: "format", value: "json"),
            .init(name: "query", value: query)
        ]
        
        var request = URLRequest(url: components.url!)
        request.timeoutInterval = requestTimeout
        request.setValue("application/sparql-results+json", forHTTPHeaderField: "Accept")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
}
