//
//  ListOfSongsView.swift
//  itunes_app
//
//  Created by Admin on 15.10.2023.
//

import Foundation


protocol ListOfSongsViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var listOfSongsPresenter: ListOfSongsPresenterProtocol? { get set }
    func showListOfSongs(_ model: [SongModel])
}
