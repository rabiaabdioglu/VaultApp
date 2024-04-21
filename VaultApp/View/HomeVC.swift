//
//  HomeVC.swift
//
//  Created by Rabia Abdioğlu on 22.02.2024.
//
//
//
// MyViewController.swift

import NeonSDK
import UIKit

class HomeVC: UIViewController {
    
    // v{h{home- icon} - v{  h{label image} h{custombutons} v{custombuttons}}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        
        let navigationView = NavigationView(leftImageName: "", title: "Home", rightImageName: "gearshape")
        view.addSubview(navigationView)
        navigationView.rightButton.addTarget(self, action: #selector(goSettingsVC), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        
        
        let containerVStack = NeonVStack(width: view.frame.width , block: { containerVStack in
            
            let labelImageHStack = NeonHStack(height: 30 , block: { labelImageHStack in
                let labelsVStack = NeonVStack(width: view.frame.width , block: { labelsVStack in
                    
                    let titleLabel = UILabel()
                    titleLabel.text = "Encrypted Safe Vault"
                    titleLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
                    titleLabel.textColor = .styledGray
                    labelsVStack.addSubview(titleLabel)
                    titleLabel.snp.makeConstraints { make in
                        make.height.equalToSuperview().multipliedBy(0.3)
                        make.leading.equalToSuperview().offset(20)
                        
                    }
                    let subtitleLabel = UILabel()
                    subtitleLabel.font = Font.custom(size: 11, fontWeight: .Light)
                    subtitleLabel.textColor = .styledGray
                    subtitleLabel.text = "Tap on one of the following categories according to the type of item you want to keep and start saving."
                    subtitleLabel.numberOfLines = 0
                    labelsVStack.addSubview(subtitleLabel)
                    subtitleLabel.snp.makeConstraints { make in
                        make.height.equalToSuperview().multipliedBy(0.7)
                        make.leading.equalToSuperview().offset(20)
                    }
                })
                labelImageHStack.addSubview(labelsVStack)
                labelsVStack.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.6)
                    make.height.equalToSuperview().multipliedBy(0.8)
                    make.leading.equalToSuperview()
                }
                
                let sideImage = UIImageView(image:  UIImage(named: "homeEncrypt")?.withRenderingMode(.alwaysOriginal))
                sideImage.contentMode = .scaleAspectFit
                labelImageHStack.addSubview(sideImage)
                sideImage.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.8)
                    make.trailing.equalToSuperview()
                }
                
            })
            containerVStack.addArrangedSubview(labelImageHStack)
            labelImageHStack.backgroundColor = .styledWhite1
            labelImageHStack.layer.cornerRadius = 10
            labelImageHStack.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalToSuperview().multipliedBy(0.2)
                make.top.equalTo(50)
                
            }
            
            // Shadow for label ımage container
            let shadowView = UIView()
            shadowView.getShadow()
            containerVStack.addSubview(shadowView)
            containerVStack.sendSubviewToBack(shadowView)
            shadowView.snp.makeConstraints { make in
                make.edges.equalTo(labelImageHStack.snp.edges)
            }
            
            containerVStack.addSpacer(15)
            
            let circleButtonsHStack = NeonHStack(height: 30 , block: { buttonStack in
                
                // album notes
                let albumView = CircleButtonWithText(imageName: "photo", title: "Albums")
                albumView.button.addTarget(self, action: #selector(goAlbumVC), for: .touchUpInside)
                buttonStack.addSubview(albumView)
                albumView.snp.makeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(0.4)
                    make.height.equalToSuperview()
                }
                //Note
                let notesView = CircleButtonWithText(imageName: "listPurple", title: "Notes")
                notesView.button.addTarget(self, action: #selector(goNoteVC), for: .touchUpInside)
                buttonStack.addSubview(notesView)
                notesView.snp.makeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(0.4)
                    make.height.equalToSuperview()
                }
                
            })
            circleButtonsHStack.spacing = 10
            containerVStack.addArrangedSubview(circleButtonsHStack)
            circleButtonsHStack.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.6)
                make.height.equalToSuperview().multipliedBy(0.16)
                
            }
            
            
            
            let buttonsVStack = NeonVStack(width: view.frame.width , block: { buttonVStack in
                
                // browser password
                
                let browserButton =  RectangleButton(leftImageName: "browser", title: "Private Browser", rightImageName: "doubleArrow")
                buttonVStack.addSubview(browserButton)
                browserButton.action = {
                    
                }
                browserButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.45)
                    
                }
                let passwordButton =  RectangleButton(leftImageName: "lock", title: "Password", rightImageName: "doubleArrow")
                passwordButton.action = {
                    let passwordVC   = PasswordsVC()
                    self.present(destinationVC: passwordVC, slideDirection: .right)
                }
                buttonVStack.addSubview(passwordButton)
                passwordButton.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.45)
                }
            })
            
            containerVStack.addArrangedSubview(buttonsVStack)
            
            buttonsVStack.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.22)
                make.top.equalTo(circleButtonsHStack.snp.bottom).offset(30)
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
    
    
    
    @objc func goSettingsVC(){
        
        let settingsVC   = SettingsVC()
        self.present(destinationVC: settingsVC, slideDirection: .right)
        
    }
    @objc func goAlbumVC(){
        let albumsVC   = AlbumsVC()
        self.present(destinationVC: albumsVC, slideDirection: .right)
        
    }
    @objc func goNoteVC(){
        
        let noteVC   = NotesVC()
        self.present(destinationVC: noteVC, slideDirection: .right)
        
    }
    
}
