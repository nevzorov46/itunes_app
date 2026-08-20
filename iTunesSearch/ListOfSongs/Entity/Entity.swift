//
//  Entity.swift
//  iTunesSearch
//
//  Created by Admin on 12.10.2023.
//

import Foundation

struct ResultModel: Decodable {
    var results: [SongModel]
}

struct SongModel: Decodable {
    var artistName: String?
    var trackName: String?
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
}

extension SongModel {
    /// Some entries (audiobooks, compilations) have no track name.
    var displayTitle: String? {
        trackName ?? collectionName
    }

    var thumbnailURL: URL? {
        artworkUrl100.flatMap(URL.init)
    }

    /// iTunes serves the same artwork in other sizes at a predictable path,
    /// so 100x100 would look blurry on the details screen.
    var largeArtworkURL: URL? {
        artworkUrl100
            .map { $0.replacingOccurrences(of: "100x100", with: "600x600") }
            .flatMap(URL.init)
    }
}
