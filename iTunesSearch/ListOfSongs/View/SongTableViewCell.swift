//
//  SongTableViewCell.swift
//  iTunesSearch
//
//  Created by Admin on 14.10.2023.
//

import UIKit
import SnapKit
import SDWebImage

class SongTableViewCell: UITableViewCell {
    
    static let id = "SongTableViewCell"
    static let artworkSide: CGFloat = 56
    static let height: CGFloat = 72

    private lazy var mainText: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var additionalText: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var mainImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.backgroundColor = .secondarySystemFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.sd_cancelCurrentImageLoad()
        mainImage.image = nil
    }
    
    func configure(with model: SongModel) {
        self.mainText.text = model.displayTitle
        self.additionalText.text = model.artistName
        self.mainImage.sd_setImage(with: model.thumbnailURL)
    }
    
    private func setupCell() {
        contentView.addSubview(mainImage)
        contentView.addSubview(mainText)
        contentView.addSubview(additionalText)
        
        mainImage.snp.makeConstraints {
            $0.width.height.equalTo(Self.artworkSide)
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        mainText.snp.makeConstraints {
            $0.left.equalTo(mainImage.snp.right).offset(12)
            $0.right.equalToSuperview().offset(-8)
            $0.top.equalTo(mainImage).offset(4)
        }
        
        additionalText.snp.makeConstraints {
            $0.left.right.equalTo(mainText)
            $0.top.equalTo(mainText.snp.bottom).offset(2)
        }
    }
}
