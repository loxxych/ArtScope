//
//  ImageAssets.swift
//  ArtScope
//
//  Created by loxxy on 25.01.2026.
//

import UIKit

enum AppImages {
    static let defaultProfile = UIImage(named: "defaultProfilePicture")
    static let defaultArtistPreview = UIImage(named: "defaultProfilePicture") ?? UIImage(systemName: "person.crop.circle.fill")
    static let palette = UIImage(named: "palette") ?? UIImage(systemName: "paintpalette.fill")
    static let paintbrush = UIImage(named: "paintbrush-icon") ?? UIImage(systemName: "paintbrush.pointed.fill")
    static let info = UIImage(named: "info-icon") ?? UIImage(systemName: "info.circle.fill")
    static let checkmark = UIImage(named: "checkmark-icon") ?? UIImage(systemName: "checkmark.seal.fill")
    static let dislike = UIImage(named: "dislike-icon") ?? UIImage(systemName: "xmark.circle")
    static let leaderboard = UIImage(named: "leaderboard-icon") ?? UIImage(systemName: "crown.fill")
}

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
