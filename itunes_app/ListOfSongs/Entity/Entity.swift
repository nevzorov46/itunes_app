//
//  Entity.swift
//  itunes_app
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
