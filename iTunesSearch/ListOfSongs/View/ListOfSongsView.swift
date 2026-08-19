//
//  ListOfSongsView.swift
//  iTunesSearch
//
//  Created by Admin on 15.10.2023.
//

import Foundation

/// Every screen state the list can be in. One value instead of several
/// independent flags, so impossible combinations cannot be expressed.
enum ListOfSongsState {
    case initial
    case loading
    case loaded([SongModel])
    case empty
    case failed(String)
}

protocol ListOfSongsViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var listOfSongsPresenter: ListOfSongsPresenterProtocol? { get set }
    func render(_ state: ListOfSongsState)
}
