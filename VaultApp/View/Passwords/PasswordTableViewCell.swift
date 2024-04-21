//
//  PasswordTableViewCell.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 5.04.2024.
//

import Foundation

import Foundation
import UIKit
import NeonSDK

class PasswordTableViewCell: NeonTableViewCell<PasswordModel> {
    
    // Variables
    var password: PasswordModel?
    
    // UI Components
    var label = NeonLabel()
    var icon = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          setupSubviews()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
    func setupSubviews() {
        
        backgroundColor = .styledWhite1
        
        // Cell for blank spaces
        let cellView = UIView()
        addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.centerY.centerX.equalToSuperview()
            
        }
        // shadow
        let shadowView = UIView()
        shadowView.getShadow()
        shadowView.layer.cornerRadius = 8
        cellView.addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(cellView.snp.edges)
        }

        // Left Image
        imageView?.image = UIImage(systemName: "photo.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        cellView.addSubview(imageView!)
        imageView?.layer.masksToBounds = true
        imageView!.layer.cornerRadius = 10
        imageView!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(27)
            make.left.equalToSuperview().offset(20)
        }
        // Account Name
        label.text = "Account Name"
        label.font = Font.custom(size: 16, fontWeight: .Regular)
        label.numberOfLines = 1
        label.textColor = .styledGray
        label.sizeToFit()
        cellView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView!.snp.left).offset(50)
        }
        
    
    }
    // Configure cell
    override func configure(with password: PasswordModel) {
        super.configure(with: password)
        self.password = password
        label.text =  "\(password.accountName)"
        
        
        
        
    }
    
    
}
