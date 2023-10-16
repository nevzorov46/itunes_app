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
    var router: ListOfSongsRouter? { get set }

    // VIEW -> PRESENTER
    func searchWithText(_ text: String)
}


class ListOfSongsPresenter: ListOfSongsPresenterProtocol {
    var view: ListOfSongsViewProtocol?
    var interactor: ListOfSongsInteractorInputProtocol?
    var router: ListOfSongsRouter?

    func searchWithText(_ text: String) {
        interactor?.getSongs(text)
    }
}

extension ListOfSongsPresenter: ListOfSongsInteractorOutputProtocol {
    func didRetrieveSongs(_ model: [SongModel]) {
        view?.showListOfSongs(model)
    }
}
