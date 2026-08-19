//
//  Resources.swift
//  iTunesSearch
//
//  Created by Admin on 16.10.2023.
//

import Foundation


class Resources {
    static let getSongsURLString = "https://itunes.apple.com/search?term="
    static let albumPlaceholderImagePath = "album_placeholder"
    static let playButtonImagePath = "play_button"
    static let stopButtonImagePath = "stop_button"

    static let searchBarPlaceholder = NSLocalizedString(
        "search.placeholder", comment: "Placeholder of the search bar")
    static let noFoundSongText = NSLocalizedString(
        "search.empty", comment: "Shown when the search returns no tracks")
    static let errorInvalidURLText = NSLocalizedString(
        "error.invalidURL", comment: "Shown when the search query cannot be turned into a valid URL")
    static let errorTransportText = NSLocalizedString(
        "error.transport", comment: "Shown when the request fails to reach the server")
    static let errorEmptyResponseText = NSLocalizedString(
        "error.emptyResponse", comment: "Shown when the server responds without a body")
    static let errorDecodingText = NSLocalizedString(
        "error.decoding", comment: "Shown when the server response cannot be decoded")
}
