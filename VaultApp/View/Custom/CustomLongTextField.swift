//
//  CustomLongTextField.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 7.04.2024.
//

import Foundation
import NeonSDK
import UIKit


class CustomLongTextView: UITextView {
    
    private let defaultPlaceholder = "Text Here"
    let attributedString = NSMutableAttributedString(string: "Başlık\nİçerik")

 
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
        updatePlaceholder()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .styledWhite4
        layer.borderColor = UIColor.styledGray3.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        font = Font.custom(size: 16, fontWeight: .Light)
        autocorrectionType = .no
        
        updatePlaceholder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updatePlaceholder() {
        if text == nil || text.isEmpty {
            attributedText = NSAttributedString(string: defaultPlaceholder, attributes: [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    @objc private func textChanged() {

        if textColor == .lightGray {
            text = ""
        }
        
        textColor = .styledGray
        font = Font.custom(size: 16, fontWeight: .Regular)

//        // Title
//        font = Font.custom(size: 20, fontWeight: .SemiBold)
//        
//        if let lastCharacter = text.last, lastCharacter == "\n" {
//            text += "\n"
//            // Content
//            font = Font.custom(size: 16, fontWeight: .Regular)
//        }
        
    }
    @objc private  func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            
            updatePlaceholder()
        }
    }
}
