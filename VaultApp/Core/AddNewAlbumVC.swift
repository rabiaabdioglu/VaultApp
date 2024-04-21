//
//  AddNewAlbumVC.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
//
//
//import Foundation
//import UIKit
//import NeonSDK
//
//class AddNewAlbumVC: UIViewController {
//    
//    var password: PasswordModel? = nil
//    let addNewAlbumView = AddNewForm(title: "Album Name")
//
//   
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.styledBlue
//        setupUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//    }
//    
//    
//    
//    func setupUI() {
//        
//        let navigationView = NavigationView(leftImageName: "leftArrow", title: "Edit Account", rightImageName: "plus")
//        view.addSubview(navigationView)
//        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
//        navigationView.rightButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
//        navigationView.snp.makeConstraints { make in
//            make.height.equalToSuperview().multipliedBy(0.1)
//            make.width.equalToSuperview()
//            make.top.equalTo(view.snp.top).offset(40)
//        }
//        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.styledWhite2
//        backgroundView.layer.cornerRadius = 30
//        view.addSubview(backgroundView)
//        backgroundView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.height.equalTo(view.snp.height).multipliedBy(0.86)
//            make.width.equalToSuperview()
//            make.top.equalTo(navigationView.snp.bottom).offset(10)
//        }
//        
//        backgroundView.addSubview(addNewAlbumView)
//        addNewAlbumView.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.25)
//            make.centerX.centerY.equalToSuperview()
//        }
//     
//        
// 
//        
//    }
//    
//
//    @objc func goBack() {
//        self.dismiss(animated: true)
//    }
//    @objc func addButtonTapped() {
//
//        addNewAlbumView.textFieldView.openKeyboard()
//
//    }
//    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let userInfo = notification.userInfo,
//           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//            let keyboardHeight = keyboardFrame.height
//            UIView.animate(withDuration: 0.3) { [self] in
//                
//                addNewAlbumView.snp.makeConstraints { make in
//                    make.width.equalToSuperview()
//                    make.height.equalToSuperview().multipliedBy(0.25)
//                    make.centerX.equalToSuperview()
//                    make.bottom.equalTo(view.snp.bottom).offset(-keyboardHeight  - 50)
//                }}
//        }
//    }
//    @objc func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) { [self] in
//            view.layoutIfNeeded()
//        }
//    }
//    
//    
//    func saveButtonTapped() {
//        self.dismiss(animated: true)
//    }
//    
//    
//    
//    
//}
//
//
//class AddNewForm: UIView{
//    var textFieldView = CustomTextFieldWithShadow()
//    
//    init(frame: CGRect = .zero,  title: String) {
//        
//        super.init(frame: frame)
//        textFieldView.setPlaceholder(title)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupUI(){
//        backgroundColor = .red
//        addSubview(textFieldView)
//        textFieldView.snp.makeConstraints { make in
//            make.width.equalToSuperview().multipliedBy(0.9)
//            make.height.equalTo(50)
//        }
//        
//        
//        let buttonsHStack = NeonHStack(height: 100 , block: { buttonsHStack in
//            
//            let cancelButton = CustomButton(title: "Cancel")
//            
//            cancelButton.titleLbl.backgroundColor = UIColor.styledWhite2
//            cancelButton.titleLbl.textColor = .styledBlack1
//            cancelButton.action = {
//                self.isHidden = true
//                
//            }
//            buttonsHStack.addSubview(cancelButton)
//            cancelButton.snp.makeConstraints { make in
//                make.width.equalToSuperview().multipliedBy(0.45)
//                make.height.equalToSuperview()
//                
//            }
//            
//            
//            let saveButton = CustomButton(title: "Save")
//            saveButton.titleLbl.backgroundColor = UIColor.styledBlue
//            saveButton.titleLbl.textColor = .styledWhite3
//          
//            buttonsHStack.addSubview(saveButton)
//            saveButton.snp.makeConstraints { make in
//                make.width.equalToSuperview().multipliedBy(0.45)
//                make.height.equalToSuperview()
//            }
//            
//            
//        })
//        buttonsHStack.alignment = .center
//        addSubview(buttonsHStack)
//        buttonsHStack.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.9)
//            make.height.equalTo(50)
//            make.bottom.equalTo(snp.bottom)
//            
//        }
//    }
//}
