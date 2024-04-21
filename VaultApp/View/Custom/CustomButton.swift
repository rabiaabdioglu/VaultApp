//
//  CustomButton.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 5.04.2024.
//


import Foundation
import UIKit
import NeonSDK

final class CustomButton: UIView {
    
    var button = UIButton()

    
    init(frame: CGRect = .zero, title: String) {

        super.init(frame: frame)
        setupUI(title: title)
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {

        // Shadow for button container
        let shadowView = UIView()
        shadowView.getShadow()
        shadowView.layer.cornerRadius = 10
        addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel!.textColor = .styledGray
        button.titleLabel!.font = Font.custom(size: 16, fontWeight: .Light)
        button.setTitle(title, for: .normal)
        button.titleLabel!.textAlignment = .center
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }

        
   }
  
    
    }
