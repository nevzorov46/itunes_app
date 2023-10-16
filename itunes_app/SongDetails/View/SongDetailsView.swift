//
//  SongDetailsView.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation

protocol SongDetailsViewProtocol: AnyObject {
    var presenter: SongDetailsPresenterProtocol? { get set }
    func playSong(with url: String?)
    func stopSong()
}
