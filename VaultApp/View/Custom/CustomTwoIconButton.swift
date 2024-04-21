//
//  RectangleButton.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//


import Foundation
import UIKit
import NeonSDK

final class RectangleButton: UIView {
    
    internal let titleLbl: UILabel
  
    var action: (() -> Void)?
    
    init(frame: CGRect = .zero, leftImageName: String, title: String, rightImageName: String) {
   
        self.titleLbl = UILabel()
        
        super.init(frame: frame)
        
        setupUI(leftImageName: leftImageName, title: title, rightImageName: rightImageName)
        // Gesture recognizer setup
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
             addGestureRecognizer(tapGesture)
             isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(leftImageName: String, title: String, rightImageName: String) {
    
        
        self.layer.cornerRadius = 10
        
        // Shadow for button container
        let shadowView = UIView()
        shadowView.getShadow()
        shadowView.layer.cornerRadius = 10
        addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
        
        let leftImageView = UIImageView(image: UIImage(named: leftImageName)!.withRenderingMode(.alwaysOriginal))
        leftImageView.contentMode = .scaleAspectFit
        addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        titleLbl.textColor = .styledGray
        titleLbl.font = Font.custom(size: 16, fontWeight: .Light)
        titleLbl.text = title
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
        
        }
        let rightImageView = UIImageView(image: UIImage(named: rightImageName)!.withRenderingMode(.alwaysOriginal))
        rightImageView.contentMode = .scaleAspectFit
        addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        
        
        
    }
    @objc private func buttonTapped() {
        action?()
    }
    
    }
