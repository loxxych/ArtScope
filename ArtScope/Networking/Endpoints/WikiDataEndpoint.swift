//
//  Endpoints.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

enum WikidataEndpoint {
    static let baseURL = URL(string: "https://query.wikidata.org")!

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
            SELECT ?artist ?artistLabel ?image WHERE {
              ?artist wdt:P31 wd:Q5;
                      wdt:P106 wd:Q1028181.
              OPTIONAL { ?artist wdt:P18 ?image. }
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
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
}
