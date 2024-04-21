//
//  SelectedNoteVC.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
import UIKit
import NeonSDK

class SelectedNoteVC: UIViewController {
    
    var note : NoteModel? = nil
    var longTextView = CustomLongTextView()
    var addNewNoteViewStack = NeonVStack()
    var textFieldView = CustomTextFieldWithShadow()
    let saveButton = CustomButton(title: "Save")

    let navigationView = NavigationView(leftImageName: "leftArrow", title: "Notes", rightImageName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        
        setupUI()
        if note != nil {
            saveButton.button.setTitle("Update", for: .normal)
            longTextView.textColor = .styledGray
            longTextView.text = note!.noteTitle
            longTextView.text! += "\n"
            longTextView.text! += note!.noteContent
        }
    }
    
    // MARK: - UI SETUP
    
    
    func setupUI() {
        // Navigation View
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        // BackGround
        let backgroundView = UIView()
        backgroundView.backgroundColor = .styledWhite1
        backgroundView.layer.cornerRadius = 30
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.86)
            make.width.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(10)
        }
        
        backgroundView.addSubview(longTextView)
        longTextView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.top.equalTo(backgroundView.snp.top).offset(30)
            make.centerX.equalToSuperview()
        }
        
        
        addNewNoteViewStack = NeonVStack(width: view.frame.width , block: { addNewNoteViewStack in
            
            // buttons
            let buttonsHStack = NeonHStack(height: 100 , block: { buttonsHStack in
                
                let cancelButton = CustomButton(title: "Cancel")
                cancelButton.button.backgroundColor = .styledWhite2
                cancelButton.button.setTitleColor(.styledBlack1, for: .normal)
                cancelButton.button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
                buttonsHStack.addSubview(cancelButton)
                cancelButton.snp.makeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(0.47)
                    make.height.equalToSuperview()
                    make.leading.equalTo(1)
                }
                
                
                saveButton.button.backgroundColor = .styledBlue
                saveButton.button.setTitleColor(.styledWhite3, for: .normal)
                saveButton.button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
                buttonsHStack.addSubview(saveButton)
                saveButton.snp.makeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(0.47)
                    make.height.equalToSuperview()
                }
                
                
            })
            buttonsHStack.alignment = .center
            addNewNoteViewStack.addSubview(buttonsHStack)
            buttonsHStack.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.4)
            }
        })
        addNewNoteViewStack.alignment = .center
        backgroundView.addSubview(addNewNoteViewStack)
        addNewNoteViewStack.snp.makeConstraints { make in
            make.bottom.equalTo(longTextView.snp.bottom).inset(20)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        backgroundView.bringSubviewToFront(addNewNoteViewStack)
        
        
    }
    
    
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    
    
    
    @objc  func saveButtonTapped() {
        navigationView.rightButton.isHidden = false
        navigationView.titleLabel.text = textFieldView.getText()
        
        // Formdaki verileri al
        guard let noteContent = longTextView.text else {
            print("Please enter note content.")
            return
        }
        let (noteTitle, noteContentRemaining) = NoteModel.splitNoteContent(noteContent)

        if let note = note {
            let updatedNote = NoteModel(id: note.id, noteTitle: noteTitle, noteContent: noteContentRemaining)
            // Update note
            FirebaseService.shared.updateNote(updatedNote: updatedNote) { error in
                if let error = error {
                    // Error
                    self.getAlert(title: "Error", message: "An error occurred while updating note")
                } else {
                    // Success
                    self.getAlert(title: "Success", message: "Note updated successfully")
                }
            }
            
            
        }
        
        else{
            
            let newNote = NoteModel(id: UUID(), noteTitle: noteTitle, noteContent: noteContentRemaining)
            
            // save note to firebase
            FirebaseService.shared.saveNote(newNote) { [self] error in
                if let error = error {
                    // Error
                    self.getAlert(title: "Error", message: "An error occurred while deleting note")
                } else {
                    // Success
                    self.getAlert(title: "Success", message: "Note saved successfully")
                }
            }
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






