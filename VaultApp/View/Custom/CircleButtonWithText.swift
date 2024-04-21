//
//  CircleButtonWithText.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
import UIKit
import NeonSDK

final class CircleButtonWithText: UIView {
    
     let button: UIButton
    private let buttonLabel: UILabel
    
    init(frame: CGRect = .zero, imageName: String, title: String) {
        self.button = UIButton()
        self.buttonLabel = UILabel()
        
        super.init(frame: frame)
        
        setupUI(imageName: imageName, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(imageName: String, title: String) {
        
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .styledWhite2
        button.layer.cornerRadius = 40
        addSubview(button)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(snp.width).multipliedBy(0.9)
            make.top.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
            
        }
        
        // Shadow for button container
        let shadowView = UIView()
        shadowView.getShadow()
        shadowView.layer.cornerRadius = 40
        addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(button.snp.edges)
        }
        
        buttonLabel.text = title
        buttonLabel.tintColor = .black
        buttonLabel.font = Font.custom(size: 14, fontWeight: .Light)
        buttonLabel.textAlignment = .center
        addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
            
        }
        
    }
}
