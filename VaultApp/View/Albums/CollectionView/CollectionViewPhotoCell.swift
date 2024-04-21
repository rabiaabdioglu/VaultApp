//
//  CollectionViewPhotoCell.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 7.04.2024.
//


import Foundation
import UIKit
import NeonSDK

class CollectionViewPhotoCell: NeonCollectionViewCell<PhotoModel> {

    // Variables
    var photo: PhotoModel?
    static let identifier = "CollectionViewPhotoCell"
  
    var imageView = NeonImageView()
    let customView = UIView()

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
        layer.cornerRadius = 10
        getShadow()
        imageView.backgroundColor = .styledWhite1
        imageView.image = UIImage(named: "plusDark")
        imageView.image!.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(contentView.snp.width)
            make.centerX.equalToSuperview()
        }
       
        
        addSubview(customView)
        customView.snp.makeConstraints { make in
            make.width.height.equalTo(contentView.snp.width)
            make.centerX.equalToSuperview()
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .styledGrayWithAlpha
        backgroundView.layer.cornerRadius = 10
        customView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        let plusImageView = UIImageView(image: UIImage(named: "tick"))
        plusImageView.contentMode = .scaleAspectFit
        customView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints { make in
            make.right.bottom.equalTo(0).offset(-10)
            make.width.height.equalTo(customView.snp.width).multipliedBy(0.15)
        }
        
        bringSubviewToFront(customView)
        customView.isHidden = !isSelected
 
 
        
    }
    // Configure cell
    override func configure(with photo: PhotoModel) {
        self.photo = photo
        isSelected = photo.isSelected
        self.customView.isHidden = !isSelected

        if photo.photoURL == "firstCellPlus" {
            imageView.snp.remakeConstraints { make in
                make.width.height.equalTo(contentView.snp.width).multipliedBy(0.4)
                make.centerX.centerY.equalToSuperview()
            }
            imageView.image = UIImage(named: "plusDark")
        } else {
            imageView.snp.remakeConstraints { make in
                make.width.height.equalTo(contentView.snp.width) // Reset to default size
                make.centerX.centerY.equalToSuperview()
            }
            if let imageUrl = URL(string: photo.photoURL) {
                imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "photo.fill"), options: [], completed: nil)
            }
        }
 
        
        
    }

    
    
}
