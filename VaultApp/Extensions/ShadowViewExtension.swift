//
//  ShadowView.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
import UIKit
extension UIView {
    
    func getShadow(){
        layer.shadowColor = UIColor.styledGray5.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 10
//        layer.cornerRadius = 20
        backgroundColor = .styledWhite1
        layer.masksToBounds = false
    }
    
    
    
}
