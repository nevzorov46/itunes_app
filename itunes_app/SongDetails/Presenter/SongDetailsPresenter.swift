//
//  SongDetailsPresenter.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation


protocol SongDetailsPresenterProtocol: AnyObject {
    var view: SongDetailsViewProtocol? { get set }
    var song: String? { get set }
    func playSong()
}


class SongDetailsPresenter: SongDetailsPresenterProtocol {
    var view: SongDetailsViewProtocol?
    var song: String?
    
    var isPlaying = false
    
    func playSong() {
        if isPlaying {
            view?.stopSong()
            isPlaying = false
        } else {
            view?.playSong(with: song)
            isPlaying = true
        }
    }
}

