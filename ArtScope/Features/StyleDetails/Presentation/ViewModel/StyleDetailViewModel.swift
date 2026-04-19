//
//  StyleDetailViewModel.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import Foundation

final class StyleDetailViewModel {
    enum State {
        case loading
        case loaded(StyleDetailContent)
        case failed(String)
    }

    private let service: StyleDetailsService

    var onStateChanged: ((State) -> Void)?

    init(service: StyleDetailsService) {
        self.service = service
    }

    func load(style: StylePreview) {
        onStateChanged?(.loading)

        service.fetchStyleDetails(style: style) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(content):
                    self?.onStateChanged?(.loaded(content))
                case let .failure(error):
                    self?.onStateChanged?(.failed(Self.message(for: error)))
                }
            }
        }
    }

    private static func message(for error: Error) -> String {
        let description = (error as NSError).localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        if description.isEmpty {
            return "Failed to load style details."
        }
        return description
    }
}
