//
//  ListOfSongsPresenter.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation

protocol ListOfSongsPresenterProtocol: AnyObject {
    var view: ListOfSongsViewProtocol? { get set }
    var interactor: ListOfSongsInteractorInputProtocol? { get set }
    var router: ListOfSongsRouterProtocol? { get set }

    // VIEW -> PRESENTER
    func searchWithText(_ text: String)
    func didSelectSong(at index: Int)
}


class ListOfSongsPresenter: ListOfSongsPresenterProtocol {
    weak var view: ListOfSongsViewProtocol?
    var interactor: ListOfSongsInteractorInputProtocol?
    var router: ListOfSongsRouterProtocol?

    private var songs: [SongModel] = []

    func searchWithText(_ text: String) {
        interactor?.getSongs(text)
    }

    func didSelectSong(at index: Int) {
        guard songs.indices.contains(index) else { return }
        router?.showSongDetails(for: songs[index])
    }
}

extension ListOfSongsPresenter: ListOfSongsInteractorOutputProtocol {
    func didRetrieveSongs(_ model: [SongModel]) {
        songs = model
        view?.showListOfSongs(model)
    }

    func didFailToRetrieveSongs(_ error: NetworkError) {
        songs = []
        view?.showError(error.localizedDescription)
    }
}
