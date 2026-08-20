//
//  SongDetailsViewController.swift
//  iTunesSearch
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
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .secondarySystemFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        return image
    }()
    
    lazy private var songName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy private var authorName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    lazy private var playButton: UIButton = {
        let button = UIButton()
        button.setImage(Self.icon("play.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        return button
    }()
    
    
    private static func icon(_ name: String) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .regular)
        return UIImage(systemName: name, withConfiguration: config)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        configureView()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.removeAllItems()
        Self.deactivateAudioSession()
    }

    /// Without the playback category the preview stays silent
    /// when the ringer switch is off.
    private static func activateAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback)
        try? session.setActive(true)
    }

    private static func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    private func configureView() {
        guard let model = model else { return }
        self.songName.text = model.displayTitle
        self.authorName.text = model.artistName
        
        self.mainImage.sd_setImage(with: model.largeArtworkURL)
    }
    
    private func setupView() {
        view.addSubview(mainImage)
        view.addSubview(songName)
        view.addSubview(authorName)
        view.addSubview(playButton)
        
        mainImage.snp.makeConstraints {
            $0.width.height.equalTo(240)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        songName.snp.makeConstraints {
            $0.top.equalTo(mainImage.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        authorName.snp.makeConstraints {
            $0.top.equalTo(songName.snp.bottom).offset(8)
            $0.left.right.equalTo(songName)
        }
        
        playButton.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.top.equalTo(authorName.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func play() {
        presenter?.playSong()
    }
}

extension SongDetailsViewController: SongDetailsViewProtocol {

    func playSong(with url: String?) {
        self.playButton.setImage(Self.icon("stop.circle.fill"), for: .normal)
        guard let urlString = url, let url = URL(string: urlString) else { return }
        Self.activateAudioSession()
        player.removeAllItems()
        player.insert(AVPlayerItem(url: url), after: nil)
        player.play()
    }
    
    func stopSong() {
        self.playButton.setImage(Self.icon("play.circle.fill"), for: .normal)
        player.removeAllItems()
        Self.deactivateAudioSession()
    }
}
	
