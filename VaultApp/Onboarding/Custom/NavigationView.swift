//
//  NavigationView.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//
import UIKit

final class NavigationView: UIView {
     let leftButton: UIButton
     let titleLabel: UILabel
     let rightButton: UIButton
  
    init(frame: CGRect = .zero, leftImageName: String, title: String, rightImageName: String) {
        self.leftButton = UIButton()
        self.rightButton = UIButton()
        self.titleLabel = UILabel()
        
        super.init(frame: frame)
        
        setupUI(leftImageName: leftImageName, title: title, rightImageName: rightImageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(leftImageName: String, title: String, rightImageName: String) {
        self.backgroundColor = .styledBlue
        
        if !leftImageName.isEmpty {
            leftButton.setImage(UIImage(named: leftImageName)?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .normal)
            leftButton.contentMode = .scaleAspectFit
            addSubview(leftButton)
            leftButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(30)
                make.centerY.equalToSuperview()
                make.width.equalTo(12)
                make.height.equalTo(18)
            }
        }
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        titleLabel.textColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        if !rightImageName.isEmpty {
            rightButton.setImage(UIImage(named: rightImageName)?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .normal)
            rightButton.contentMode = .scaleAspectFit
            addSubview(rightButton)
            rightButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-30)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
            }
        }
    }
}
