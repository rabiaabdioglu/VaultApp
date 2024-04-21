//
//  CustomTextField.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 5.04.2024.
//


import NeonSDK
import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          setupTextUI()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          setupTextUI()
      }
    
    func setupTextUI(){
 
        self.tintColor = UIColor.orange
        
        self.backgroundColor = .white
        self.textColor = .styledGray
        self.clipsToBounds = false
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.font = Font.custom(size: 16, fontWeight: .Regular)
  
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
}
class CustomTextFieldWithShadow : UIView{
        private let textField = CustomTextField()

        override init(frame: CGRect) {
              super.init(frame: frame)
              setupTextUI()
          }
          
          required init?(coder: NSCoder) {
              super.init(coder: coder)
              setupTextUI()
          }
        
        func setupTextUI(){
            // Shadow for label
            let shadowView = UIView()
            shadowView.getShadow()
            shadowView.layer.cornerRadius = 8
            self.addSubview(shadowView)
            self.sendSubviewToBack(shadowView)
            shadowView.snp.makeConstraints { make in
                make.edges.equalTo(snp.edges)
            }
            
            textField.layer.cornerRadius = 8
            self.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.edges.equalTo(snp.edges)
            }
           
            
        }
        // MARK: - Public Methods
        
        func setPlaceholder(_ text: String) {
            textField.placeholder = text
        }
        
        func setText(_ text: String?) {
            textField.text = text
        }
        
    func getText() -> String? {
        return textField.text
    }
    func openKeyboard() {
         textField.becomeFirstResponder()
     }
        
    }
   
    
