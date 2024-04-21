//
//  CollectionViewAlbumCell.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 7.04.2024.
//


import Foundation
import UIKit
import NeonSDK

class CollectionViewAlbumCell: NeonCollectionViewCell<AlbumModel> {
    //class CollectionViewAlbumCell: UICollectionViewCell {
    
    // Variables
    var album: AlbumModel?
    static let identifier = "CollectionViewAlbumCell"
    
    var imageView = NeonImageView()
    var albumNameLabel = UILabel()
    var photoCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup Constraints
    func setupViews() {
        backgroundColor = .clear
        imageView.backgroundColor = .styledWhite1
        imageView.image = UIImage(systemName: "photo.stack.fill")!.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(contentView.snp.height).multipliedBy(0.65)
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.top)
        }
        
        
        let shadowView = UIView()
        shadowView.getShadow()
        addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.center.equalTo(imageView.snp.center)
            make.width.height.equalTo(imageView.snp.width).multipliedBy(0.9)
        }
        
        
        albumNameLabel.font = Font.custom(size: 16, fontWeight: .Medium)
        albumNameLabel.textColor = .styledGray
        albumNameLabel.textAlignment = .center
        albumNameLabel.numberOfLines = 0
        addSubview(albumNameLabel)
        albumNameLabel.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.width).multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        photoCountLabel.font = Font.custom(size: 12, fontWeight: .Light)
        photoCountLabel.textColor = .styledGray6
        photoCountLabel.textAlignment = .center
        addSubview(photoCountLabel)
        photoCountLabel.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.width).multipliedBy(0.1)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(albumNameLabel.snp.bottom).offset(5)
        }
        
        
        
        
    }
    // Configure cell
    override func configure(with album: AlbumModel) {
        self.album = album
        
        if album.albumCoverPhotoURL != "" {
            if let imageUrl = URL(string: album.albumCoverPhotoURL) {
                imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "photo.stack")?.withTintColor(.styledGray, renderingMode: .alwaysOriginal), options: [], completed: nil)
            }
        }
        else{
            imageView.image = UIImage(systemName: "photo.stack.fill")!.withTintColor(.lightGray, renderingMode: .alwaysOriginal)

        }
        
        albumNameLabel.text = album.albumName
        photoCountLabel.text = "\(album.photosCount) Photos"
        
    }
    
    
}
