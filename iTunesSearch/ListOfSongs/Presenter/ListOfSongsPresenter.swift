//
//  ListOfSongsPresenter.swift
//  iTunesSearch
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
    func clearSearch()
}


class ListOfSongsPresenter: ListOfSongsPresenterProtocol {
    weak var view: ListOfSongsViewProtocol?
    var interactor: ListOfSongsInteractorInputProtocol?
    var router: ListOfSongsRouterProtocol?

    private static let minQueryLength = 3

    private var songs: [SongModel] = []

    func searchWithText(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard query.count >= Self.minQueryLength else { return }
        songs = []
        view?.render(.loading)
        interactor?.getSongs(query)
    }

    func clearSearch() {
        songs = []
        view?.render(.initial)
    }

    func didSelectSong(at index: Int) {
        guard songs.indices.contains(index) else { return }
        router?.showSongDetails(for: songs[index])
    }
}

extension ListOfSongsPresenter: ListOfSongsInteractorOutputProtocol {
    func didRetrieveSongs(_ model: [SongModel]) {
        songs = model
        view?.render(model.isEmpty ? .empty : .loaded(model))
    }

    func didFailToRetrieveSongs(_ error: NetworkError) {
        songs = []
        view?.render(.failed(error.localizedDescription))
    }
}
