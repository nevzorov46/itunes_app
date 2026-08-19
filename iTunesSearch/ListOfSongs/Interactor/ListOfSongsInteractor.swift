//
//  ListOfSongsInteractor.swift
//  iTunesSearch
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
    // INTERACTOR -> PRESENTER. Always called on the main thread,
    // so the presenter and the view stay main-thread only.
    func didRetrieveSongs(_ model: [SongModel])
    func didFailToRetrieveSongs(_ error: NetworkError)
}

class ListOfSongsInteractor: ListOfSongsInteractorInputProtocol {
    weak var presenter: ListOfSongsInteractorOutputProtocol?

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol = NetworkService.shared) {
        self.network = network
    }

    func getSongs(_ name: String) {
        network.getSongs(name, completionHandler: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.presenter?.didRetrieveSongs(model.results)
                case .failure(let error):
                    self.presenter?.didFailToRetrieveSongs(error)
                }
            }
        })
    }
}

