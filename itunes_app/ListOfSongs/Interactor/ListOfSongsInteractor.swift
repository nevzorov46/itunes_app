//
//  ListOfSongsInteractor.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation

protocol ListOfSongsInteractorProtocol {
    var presenter: ListOfSongsPresenter? { get set }
    func getSongs(_ name: String)
}

protocol ListOfSongsInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: ListOfSongsInteractorOutputProtocol? { get set}
    func getSongs(_ name: String)
}

protocol ListOfSongsInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func didRetrieveSongs(_ model: [SongModel])
    func didFailToRetrieveSongs(_ error: NetworkError)
}

class ListOfSongsInteractor: ListOfSongsInteractorInputProtocol {
    weak var presenter: ListOfSongsInteractorOutputProtocol?
    
    func getSongs(_ name: String) {
        NetworkService.shared.getSongs(name, completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.presenter?.didRetrieveSongs(model.results)
            case .failure(let error):
                self.presenter?.didFailToRetrieveSongs(error)
            }
        })
    }
}

