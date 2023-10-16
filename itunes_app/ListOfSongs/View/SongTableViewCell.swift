//
//  SongTableViewCell.swift
//  itunes_app
//
//  Created by Admin on 14.10.2023.
//

import UIKit
import SnapKit
import SDWebImage

class SongTableViewCell: UITableViewCell {
    
    static let id = "SongTableViewCell"
    
    private lazy var mainText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var additionalText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var mainImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with model: SongModel) {
        self.mainText.text = model.trackName
        self.additionalText.text = model.artistName
        self.mainImage.sd_setImage(with: URL(string: model.artworkUrl100 ?? ""))
    }
    
    private func setupCell() {
        addSubview(mainImage)
        addSubview(mainText)
        addSubview(additionalText)
        addSubview(separator)
        
        mainImage.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        mainText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(mainImage.snp.right).offset(5)
        }
        
        additionalText.snp.makeConstraints {
            $0.top.equalTo(mainText.snp.bottom).offset(5)
            $0.left.equalTo(mainText)
        }
        
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(mainText)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
            $0.top.equalTo(additionalText.snp.bottom).offset(2)
        }
    }
}
