//
//  ListOfSongsRouter.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation
import UIKit

protocol ListOfSongsRouterProtocol: AnyObject {
    static func createStartView() -> UIViewController
    // PRESENTER -> ROUTER
    func showSongDetails(for song: SongModel)
}

class ListOfSongsRouter: ListOfSongsRouterProtocol {
    weak var viewController: UIViewController?

    static func createStartView() -> UIViewController {
        let vc = SearchSongViewController()
        let presenter: ListOfSongsPresenterProtocol & ListOfSongsInteractorOutputProtocol = ListOfSongsPresenter()
        let interactor: ListOfSongsInteractorInputProtocol = ListOfSongsInteractor()
        let router = ListOfSongsRouter()
        vc.listOfSongsPresenter = presenter
        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = vc
        return vc
    }

    func showSongDetails(for song: SongModel) {
        let detailsView = SongDetailsRouter.createDetailsView(song)
        viewController?.present(detailsView, animated: true)
    }
}
