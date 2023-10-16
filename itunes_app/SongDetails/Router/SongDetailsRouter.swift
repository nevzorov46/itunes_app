//
//  SongDetailsRouter.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation
import UIKit


protocol SongDetailsRouterProtocol: AnyObject {
    static func createDetailsView(_ model: SongModel) -> UIViewController
}

class SongDetailsRouter: SongDetailsRouterProtocol {
    static func createDetailsView(_ model: SongModel) -> UIViewController {
        let vc = SongDetailsViewController()
        let presenter: SongDetailsPresenterProtocol = SongDetailsPresenter()
        presenter.view = vc
        presenter.song = model.previewUrl
        vc.presenter = presenter
        vc.model = model
        return vc
    }
}
