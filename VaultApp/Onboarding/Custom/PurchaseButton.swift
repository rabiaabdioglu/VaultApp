//
//  PurchaseButton.swift
//  TimeTraveling
//
//  Created by Rabia Abdioğlu on 12.03.2024.
//
//

import UIKit
import NeonSDK

final class PurchaseButton: UIView {
     let priceLabel = UILabel()
     let productTitleLabel = UILabel()
    let purchaseButton = UIButton()
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                purchaseButton.layer.borderColor = UIColor.styledBlue.cgColor
                checkIcon.isHidden = false
            } else {
                purchaseButton.layer.borderColor = UIColor.styledWhite5.cgColor
                checkIcon.isHidden = true
            }
        }
    }
    
    let checkIcon = UIImageView(image: UIImage(named:  "checkMark")?.withTintColor(.styledGray4, renderingMode: .alwaysOriginal))
    init(frame: CGRect = .zero, price: String, productTitle: String) {
        super.init(frame: frame)
        setupUI(price: price, productTitle: productTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(price: String, productTitle: String) {
        
        let shadowView = UIView()
        shadowView.getShadow()
        addSubview(shadowView)

        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        purchaseButton.backgroundColor = .styledWhite5
        purchaseButton.layer.cornerRadius = 10
        purchaseButton.layer.borderWidth = 1
        purchaseButton.layer.borderColor = UIColor.styledWhite5.cgColor
        addSubview(purchaseButton)
        purchaseButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        purchaseButton.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(15)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()

        }
        
        purchaseButton.addSubview(productTitleLabel)
        productTitleLabel.text = productTitle
        productTitleLabel.textColor = .styledGray4
        productTitleLabel.font = Font.custom(size: 18, fontWeight: .Medium)
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        productTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(checkIcon.snp.right).offset(10)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(50)
        }
        
        purchaseButton.addSubview(priceLabel)
        priceLabel.text = price
        priceLabel.textColor = .styledGray4
        priceLabel.textAlignment = .right
        priceLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        

        snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(70)
        }


    }
}



