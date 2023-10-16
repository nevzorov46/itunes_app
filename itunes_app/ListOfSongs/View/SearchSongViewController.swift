//
//  SearchSongViewController.swift
//  itunes_app
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
        view.backgroundColor = .systemGray
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.isHidden = true
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = Resources.searchBarPlaceholder
        view.delegate = self
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        return view
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = Resources.noFoundSongText
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        setupNoResultsLabel()
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
    
    private func setupNoResultsLabel() {
        view.addSubview(noResultsLabel)
        noResultsLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

extension SearchSongViewController: ListOfSongsViewProtocol {
    func showListOfSongs(_ model: [SongModel]) {
        self.model = model
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            if self.model.isEmpty {
                self.tableView.isHidden = true
                self.noResultsLabel.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.noResultsLabel.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchSongViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 2 {
            self.model = []
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = true
            self.activityIndicator.isHidden = false
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
        let item = model[indexPath.row]
        let vc = SongDetailsRouter.createDetailsView(item)
        self.present(vc, animated: true)
    }
}
