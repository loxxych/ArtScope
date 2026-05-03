//
//  ArtistOfTheDayService.swift
//  ArtScope
//
//  Created by loxxy on 03.05.2026.
//

import Foundation

final class ArtistOfTheDayService {
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let artistID = "artist_of_the_day_id"
        static let date = "artist_of_the_day_date"
    }
    
    func getArtist(from artists: [ArtistPreview]) -> ArtistPreview {
        let today = Self.currentDayString()
        
        if let savedID = defaults.string(forKey: Keys.artistID),
           let savedDate = defaults.string(forKey: Keys.date),
           savedDate == today,
           let artist = artists.first(where: { $0.id == savedID }) {
            return artist
        }
        
        let filtered = artists.filter { artist in
            guard let url = artist.imageURL else { return false }
            let ext = url.pathExtension.lowercased()
            return ["jpg", "jpeg", "png", "webp"].contains(ext)
        }
        
        let newArtist = filtered.randomElement() ?? artists[0]
        
        defaults.set(newArtist.id, forKey: Keys.artistID)
        defaults.set(today, forKey: Keys.date)
        
        return newArtist
    }
    
    private static func currentDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
