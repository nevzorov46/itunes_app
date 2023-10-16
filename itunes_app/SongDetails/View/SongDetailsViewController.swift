//
//  SongDetailsViewController.swift
//  itunes_app
//
//  Created by Admin on 14.10.2023.
//

import UIKit
import SnapKit
import SDWebImage
import AVFoundation

class SongDetailsViewController: UIViewController {

    var model: SongModel?
    internal var presenter: SongDetailsPresenterProtocol?
    
    private let player = AVQueuePlayer()

    lazy private var mainImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: Resources.albumPlaceholderImagePath)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    lazy private var songName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var authorName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Resources.playButtonImagePath), for: .normal)
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupView()
        configureView()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.removeAllItems()
    }
    
    private func configureView() {
        guard let model = model else { return }
        self.authorName.text = model.trackName
        self.songName.text = model.artistName
        
        if let imageURL = model.artworkUrl100 {
            self.mainImage.sd_setImage(with: URL(string: imageURL))
        }
    }
    
    private func setupView() {
        view.addSubview(mainImage)
        view.addSubview(songName)
        view.addSubview(authorName)
        view.addSubview(playButton)
        
        mainImage.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
        
        songName.snp.makeConstraints {
            $0.top.equalTo(mainImage.snp.bottom).offset(50)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
        }
        
        authorName.snp.makeConstraints {
            $0.top.equalTo(songName.snp.bottom).offset(10)
            $0.left.equalTo(songName)
            $0.right.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func play() {
        presenter?.playSong()
    }
}

extension SongDetailsViewController: SongDetailsViewProtocol {

    func playSong(with url: String?) {
        self.playButton.setImage(UIImage(named: Resources.stopButtonImagePath), for: .normal)
        guard let urlString = url, let url = URL(string: urlString) else { return }
        player.removeAllItems()
        player.insert(AVPlayerItem(url: url), after: nil)
        player.play()
    }
    
    func stopSong() {
        self.playButton.setImage(UIImage(named: Resources.playButtonImagePath), for: .normal)
        player.removeAllItems()
    }
}
	
