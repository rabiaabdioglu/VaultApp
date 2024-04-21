//
//  SettingsVC.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//


import NeonSDK
import UIKit

class SettingsVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        
        let navigationView = NavigationView(leftImageName: "leftArrow", title: "Settings", rightImageName: "")
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        let containerVStack = NeonVStack(width: view.frame.width , block: { containerVStack in

            
            let buttonsVStack = NeonVStack(width: view.frame.width , block: { buttonVStack in
                
                buttonVStack.addSpacer(20)
                
                let premiumButton =  RectangleButton(leftImageName: "tryPremium", title: "Try Premium", rightImageName: "rightArrow")
                premiumButton.action = { 
                    
                    print("aggsaghsgashg")
                }
                buttonVStack.addSubview(premiumButton)
                premiumButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.16)
                    
                }
                
                let contactUsButton =  RectangleButton(leftImageName: "contactUs", title: "Contact Us", rightImageName: "rightArrow")
                contactUsButton.action = {
                    
                    print("aggsaghsgashg")
                }
                buttonVStack.addSubview(contactUsButton)
                contactUsButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.16)
                }
                
                let rateUsButton =  RectangleButton(leftImageName: "rateUs", title: "Rate Us", rightImageName: "rightArrow")
                rateUsButton.action = {
                    
                    print("aggsaghsgashg")
                }
                buttonVStack.addSubview(rateUsButton)
                rateUsButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.16)
                }
                
                let privacyButton =  RectangleButton(leftImageName: "privacy", title: "Privacy Policy", rightImageName: "rightArrow")
                privacyButton.action = {
                    
                    print("aggsaghsgashg")
                }
                buttonVStack.addSubview(privacyButton)
                privacyButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.16)
                }
                
                let termsButton =  RectangleButton(leftImageName: "terms", title: "Terms of Use", rightImageName: "rightArrow")
                termsButton.action = {
                    
                    print("aggsaghsgashg")
                }
                buttonVStack.addSubview(termsButton)
                termsButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.16)
                }
            })
            
            buttonsVStack.alignment = .center
            containerVStack.addSubview(buttonsVStack)
            buttonsVStack.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(containerVStack.snp.height).multipliedBy(0.5)
                make.width.equalToSuperview()
                
            }
            
            
        })
        
        containerVStack.backgroundColor = .styledWhite1
        containerVStack.alignment = .center
        containerVStack.layer.cornerRadius = 30
        containerVStack.addSpacer(20)
        view.addSubview(containerVStack)
        containerVStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.86)
            make.width.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(10)
            
        }
        
        
    }
    
    @objc func goBack(){
        print("aggsaghsgashg")
        self.dismiss(animated: true)
    }
}
