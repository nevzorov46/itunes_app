//
//  SearchSongViewController.swift
//  iTunesSearch
//
//  Created by Admin on 14.10.2023.
//

import UIKit
import SnapKit

class SearchSongViewController: UIViewController {
    
    internal var listOfSongsPresenter: ListOfSongsPresenterProtocol?
    
    private var model: [SongModel] = []
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.id)
        view.backgroundColor = .systemBackground
        view.rowHeight = SongTableViewCell.height
        view.separatorInset = UIEdgeInsets(top: 0, left: 84, bottom: 0, right: 0)
        view.keyboardDismissMode = .onDrag
        view.delegate = self
        view.dataSource = self
        view.isHidden = true
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = Resources.searchBarPlaceholder
        view.searchBarStyle = .minimal
        view.autocapitalizationType = .none
        view.delegate = self
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Resources.noFoundSongText
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        setupMessageLabel()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
        }
    }
    
    private func setupMessageLabel() {
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().offset(20)
            $0.right.lessThanOrEqualToSuperview().offset(-20)
        }
    }
}

extension SearchSongViewController: ListOfSongsViewProtocol {
    // The presenter calls these methods on the main thread only.
    func showListOfSongs(_ model: [SongModel]) {
        self.model = model
        activityIndicator.stopAnimating()
        if model.isEmpty {
            tableView.isHidden = true
            messageLabel.text = Resources.noFoundSongText
            messageLabel.isHidden = false
        } else {
            tableView.isHidden = false
            messageLabel.isHidden = true
            tableView.reloadData()
        }
    }

    func showInitialState() {
        model = []
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        messageLabel.isHidden = true
        tableView.reloadData()
    }

    func showError(_ message: String) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        messageLabel.text = message
        messageLabel.isHidden = false
    }
}

extension SearchSongViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            listOfSongsPresenter?.clearSearch()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 2 {
            self.model = []
            self.messageLabel.isHidden = true
            self.tableView.isHidden = true
            self.activityIndicator.startAnimating()
            listOfSongsPresenter?.searchWithText(text)
        }
    }
}


extension SearchSongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SongTableViewCell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.id, for: indexPath) as? SongTableViewCell {
            let item = model[indexPath.row]
            cell.configure(with: item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listOfSongsPresenter?.didSelectSong(at: indexPath.row)
    }
}
