//
//  RemoteImageLoader.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

final class RemoteImageLoader {
    static let shared = RemoteImageLoader()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {}

    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url else {
            completion(nil)
            return
        }

        let cacheKey = url as NSURL

        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }.resume()
    }
}
