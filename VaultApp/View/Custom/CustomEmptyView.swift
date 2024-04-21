//
//  EmptyView.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 5.04.2024.
//

import Foundation
import UIKit
import NeonSDK


final class EmptyView: UIView {
    

    
    init(frame: CGRect = .zero, imageName: String, title: String, subtitle: String) {
      super.init(frame: frame)
        
        setupUI(imageName: imageName, title: title, subtitle: subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(imageName: String, title: String, subtitle: String) {
        
        // Shadow for image container
        let backGroundView = UIView()
        backGroundView.layer.cornerRadius = 40
        addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.width.height.equalTo(snp.width).multipliedBy(0.3)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        let imageView = UIImageView()

        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        imageView.backgroundColor = .styledWhite2
        imageView.layer.cornerRadius = 40
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(backGroundView.snp.width).multipliedBy(0.4)
            make.height.equalTo(backGroundView.snp.height).multipliedBy(0.5)
            make.centerX.equalTo(backGroundView.snp.centerX)
            make.centerY.equalTo(backGroundView.snp.centerY)

        }
        
        // Shadow for image container
        let shadowView = UIView()
        shadowView.getShadow()
        shadowView.layer.cornerRadius = 40
        addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(backGroundView.snp.edges)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backGroundView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }

        let subtitleLabel =  UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .black
        subtitleLabel.font = Font.custom(size: 14, fontWeight: .Light)
        subtitleLabel.textAlignment = .center
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
    }
}
