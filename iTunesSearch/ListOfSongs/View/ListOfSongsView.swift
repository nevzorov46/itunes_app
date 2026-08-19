//
//  ListOfSongsView.swift
//  iTunesSearch
//
//  Created by Admin on 15.10.2023.
//

import Foundation


protocol ListOfSongsViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var listOfSongsPresenter: ListOfSongsPresenterProtocol? { get set }
    func showListOfSongs(_ model: [SongModel])
    func showError(_ message: String)
    func showInitialState()
}
