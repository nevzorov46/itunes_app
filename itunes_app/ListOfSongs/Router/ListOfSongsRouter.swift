//
//  ListOfSongsRouter.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation
import UIKit

protocol ListOfSongsRouterProtocol {
    static func createStartView() -> UIViewController
}

class ListOfSongsRouter: ListOfSongsRouterProtocol {
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
        return vc
    }
}
