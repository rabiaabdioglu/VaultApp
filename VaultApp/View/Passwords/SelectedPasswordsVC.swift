//
//  SelectedPasswordsVC.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
import UIKit
import NeonSDK

class SelectedPasswordsVC: UIViewController {
    
    var password: PasswordModel? = nil
    
    // Text Fields
    let nameTextField = CustomTextFieldWithShadow()
    let loginAccountTextField = CustomTextFieldWithShadow()
    let passwordTextField = CustomTextFieldWithShadow()
    let websiteTextField = CustomTextFieldWithShadow()
    let saveButton = CustomButton(title: "Save")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        setupUI()
        if password != nil{
            saveButton.button.setTitle("Update", for: .normal)
            nameTextField.setText(password!.accountName)
            loginAccountTextField.setText(password!.login)
            passwordTextField.setText(password!.password)
            websiteTextField.setText(password!.website)
        }
        
    }
    
    
    
    func setupUI() {
        
        let navigationView = NavigationView(leftImageName: "leftArrow", title: "Edit Account", rightImageName: "plus")
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(clearPage), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .styledWhite1
        backgroundView.layer.cornerRadius = 30
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.86)
            make.width.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }

        let iconImageView = UIImageView(image: UIImage(named: password?.iconName ?? "photo.fill"))
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 10
        backgroundView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(view.snp.width).multipliedBy(0.22)
            make.left.equalTo(20)
            make.top.equalTo(backgroundView.snp.top).offset(30)
        }
        
        let textFieldsVStack = NeonVStack(width: view.frame.width , block: { textFieldsVStack in
            
            
            nameTextField.setPlaceholder( "Name Of The Account")
            textFieldsVStack.addSubview(nameTextField)
            nameTextField.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalTo(50)
            }
           
            loginAccountTextField.setPlaceholder("Login Account")
            textFieldsVStack.addSubview(loginAccountTextField)
            loginAccountTextField.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalTo(50)
            }
         
            passwordTextField.setPlaceholder( "Password")
            textFieldsVStack.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalTo(50)
            }
            
            websiteTextField.setPlaceholder( "Website")
            textFieldsVStack.addSubview(websiteTextField)
            websiteTextField.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalTo(50)
            }
            
            
        })
        textFieldsVStack.alignment = .center
        backgroundView.addSubview(textFieldsVStack)
        textFieldsVStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.width.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(50)
            
        }
        
        
        let buttonsHStack = NeonHStack(height: 100 , block: { buttonsHStack in
       
            let cancelButton = CustomButton(title: "Cancel")
            cancelButton.button.backgroundColor = .styledWhite1
            cancelButton.button.setTitleColor(.styledBlack1, for: .normal)
            cancelButton.button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            buttonsHStack.addSubview(cancelButton)
            cancelButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.45)
                make.height.equalToSuperview()
                
            }
            
            
            saveButton.button.backgroundColor = .styledBlue
            saveButton.button.setTitleColor(.styledWhite3, for: .normal)
            saveButton.button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            buttonsHStack.addSubview(saveButton)
            saveButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.45)
                make.height.equalToSuperview()
            }
            
    
        })     
        buttonsHStack.alignment = .center
        backgroundView.addSubview(buttonsHStack)
        buttonsHStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(textFieldsVStack.snp.bottom).offset(100)
            
        }
        
    }
    
    @objc func clearPage(){
        nameTextField.setText("")
        loginAccountTextField.setText("")
        passwordTextField.setText("")
        websiteTextField.setText("")
        
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
        // Formdaki verileri al
        // Formdaki verileri al
          guard let accountName = nameTextField.getText(),
                let login = loginAccountTextField.getText(),
                let passwordText = passwordTextField.getText(),
                let website = websiteTextField.getText() 
        
        else {

              print("Please enter all fields.")
              return
          }
          
        if let password = self.password {
         
            if password.accountName != accountName || password.login != login || password.password != passwordText || password.website != website 
                {
                // Update note
                let updatedPass = PasswordModel(id: password.id, iconName: password.iconName, accountName: accountName, login: login, password: passwordText, website: website)

                FirebaseService.shared.updatePassword(updatedPassword: updatedPass) { error in
                    if let error = error {
                        // Error
                        self.getAlert(title: "Error", message: "An error occurred while updating password")
                    } else {
                        // Success
                        self.getAlert(title: "Success", message: "Password updated successfully")
                    }
                }
            }
            
     
        }
        else{
        
       
            // PasswordModel oluştur
            let newPassword = PasswordModel(id: UUID(), iconName: "", accountName: accountName, login: login, password: passwordText, website: website)
            // Firebase'e kaydet
            FirebaseService.shared.savePassword(newPassword)
            self.getAlert(title: "Success", message: "Password saved successfully")

        }


    } 
    func getAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.goBack()
        })
        self.present(alert, animated: true, completion: nil)
    }

    
}
