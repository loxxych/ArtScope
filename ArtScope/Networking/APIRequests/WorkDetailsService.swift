//
//  WorkDetailsService.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

protocol WorkDetailsService {
    func fetchWorkDetails(
        workID: String,
        work: ArtistWork,
        artistName: String,
        completion: @escaping (Result<WorkDetailsContent, Error>) -> Void
    )
}
