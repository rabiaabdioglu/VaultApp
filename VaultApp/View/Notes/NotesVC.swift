//
//  NotesVC.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
import UIKit
import NeonSDK

class NotesVC: UIViewController ,UISearchBarDelegate{
    
    var notes: [NoteModel] = []
    var filteredNotes: [NoteModel] = []
    var notesTableView : NeonTableView<NoteModel, NoteTableViewCell>?
    
    override func viewWillAppear(_ animated: Bool) {

        fetchNotes()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        fetchNotes()
        setupTable()
        setupUI()
    }
    
    
    // MARK: - UI SETUP
    
    
    func setupUI() {
        // Navigation View
        let navigationView = NavigationView(leftImageName: "leftArrow", title: "Notes", rightImageName: "plus")
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(addNewNote), for: .touchUpInside)
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

            
        
        if notes.isEmpty {
            // No note
            let noNotesVC = EmptyView(imageName: "listBlue", title: "There is no Notes", subtitle: "You don't have any notes yet")
            view.addSubview(noNotesVC)
            noNotesVC.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.7)
                make.height.equalToSuperview().multipliedBy(0.3)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(100)
            }
        }
        else{
            // Search Bar
            let searchBar = UISearchBar()
            searchBar.autocorrectionType = .no
            searchBar.autocapitalizationType = .none
            searchBar.backgroundColor = .styledWhite1
            searchBar.tintColor = .lightGray
            searchBar.searchTextField.leftView?.removeFromSuperview()
            searchBar.searchTextField.leftViewMode = .never
            searchBar.searchTextField.backgroundColor = .white
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            
            // oldu fakat arada bir layer var gözükmüyor
            searchBar.searchTextField.layer.borderWidth = 0
            searchBar.searchTextField.layer.cornerRadius = 10
            searchBar.searchTextField.layer.masksToBounds = true
            searchBar.layer.cornerRadius = 10
            searchBar.layer.masksToBounds = true
            searchBar.layer.borderWidth = 0
            
            backgroundView.addSubview(searchBar)
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(backgroundView.snp.top).offset(35)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.066)
            }
            
            searchBar.searchTextField.snp.makeConstraints { make in
                make.edges.equalTo(searchBar.snp.edges)
                
            }

            // Shadow for searchbar
            let shadowView = UIView()
            shadowView.getShadow()
            backgroundView.addSubview(shadowView)
            backgroundView.sendSubviewToBack(shadowView)
            shadowView.snp.makeConstraints { make in
                make.edges.equalTo(searchBar.snp.edges)
            }
            
            
            // Pass List
            notesTableView!.objects = notes
            backgroundView.addSubview(notesTableView!)
            notesTableView!.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(searchBar.snp.bottom).offset(10)
            }
        }
        notesTableView?.objects = filteredNotes
        
    
}


    @objc func goBack() {
        self.dismiss(animated: true)
    }

    @objc func addNewNote() {
        
        
        let selectedNote = SelectedNoteVC()
        self.present(destinationVC: selectedNote, slideDirection: .right)

    }
    // MARK: - TABLE
    
  
    func setupTable(){
        
        // table
        notesTableView = NeonTableView<NoteModel, NoteTableViewCell>(
            objects: notes, heightForRows: view.frame.height * 0.16, style: .plain
        )
        notesTableView?.backgroundColor = .styledWhite1

        // dis select
        notesTableView?.didSelect = { [self] object, indexPath in
            let selectedNoteVC = SelectedNoteVC()
            selectedNoteVC.note = object
            self.present(destinationVC: selectedNoteVC, slideDirection: .right)
            print(filteredNotes[indexPath.item])
            
        }
        notesTableView?.trailingSwipeActions = [
            SwipeAction(title: "Delete", color: .styledRed) { [self] note, indexPath in
                deleteNote(note: note)
                fetchNotes()
                
            }
        ]
    }
    func deleteNote(note: NoteModel) {
        
        FirebaseService.shared.deleteNote(note: note, completion: { [self] error in
            if let error = error {
                // Error
                getAlert(title: "Error", message: "An error occurred while deleting notes")
                
            } else {
                getAlert(title: "Success", message: "Note deleted successfully.")
                // Success
            }
            
        })
    }
    
    func fetchNotes() {

            FirebaseService.shared.fetchNotes { [self] notesData in
                if let notesData = notesData {
                    notes = notesData
                    filteredNotes = notesData
                    notesTableView?.objects = filteredNotes
                    notesTableView?.reloadData()
                    setupUI()
                } else {
                    print("Error: Failed to fetch passwords from Firebase")
                }
            }
      }
        
    func getAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - SEARCH BAR FUNCTIONS
    // Search Functions
    func filterContentForSearchText(_ searchText: String) {
        if searchText == "" {
            filteredNotes = notes
        }
        else{
            filteredNotes = notes.filter { note in
                return note.noteTitle.lowercased().contains(searchText.lowercased())
                
            }
        }
        notesTableView?.objects = filteredNotes

    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
}
