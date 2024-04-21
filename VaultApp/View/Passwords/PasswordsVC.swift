//
//  Passwords.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//
import Foundation
import UIKit
import NeonSDK

class PasswordsVC: UIViewController ,UISearchBarDelegate{
    
    var passwords: [PasswordModel] = []
    var filteredPass: [PasswordModel] = []
    var selectedPassIndex: Int? = nil
    var passwordTable : NeonTableView<PasswordModel, PasswordTableViewCell>?
    let backgroundView = UIView()
    let headerLabel = UILabel()

    override func viewWillAppear(_ animated: Bool) {
        selectedPassIndex = nil
        fetchPasswords()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        fetchPasswords()
        setupTable()
        setupUI()
        setupTableUI()

    }
    
    // MARK: - UI SETUP
    
    
    func setupUI() {
        // Navigation View
        let navigationView = NavigationView(leftImageName: "leftArrow", title: "Social Passwords", rightImageName: "plus")
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(selectedPasswordVC), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        // BackGround
        backgroundView.backgroundColor = .styledWhite1
        backgroundView.layer.cornerRadius = 30
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.86)
            make.width.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
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
        
        // Header Label
        headerLabel.text = "All Passwords"
        headerLabel.textColor = .styledGray
        headerLabel.font = Font.custom(size: 16, fontWeight: .Regular)
        headerLabel.textAlignment = .left
        backgroundView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(searchBar.snp.left)
            make.height.equalToSuperview().multipliedBy(0.031)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.top.equalTo(searchBar.snp.bottom).offset(30)
        }
        

    }
    func setupTableUI(){
        if passwords.isEmpty {
            // No pass
            let noPasswordVC = EmptyView(imageName: "lock", title: "There is no account", subtitle: "You don't have any account yet")
            backgroundView.addSubview(noPasswordVC)
            noPasswordVC.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.7)
                make.height.equalToSuperview().multipliedBy(0.3)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(100)
            }
        }
        else{
            // Pass List
            passwordTable!.objects = passwords
            backgroundView.addSubview(passwordTable!)
            passwordTable!.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(headerLabel.snp.bottom).offset(5)
            }
        }
        passwordTable?.objects = filteredPass

    }
    
    
    // MARK: - TABLE
    
    
    func setupTable(){
        
        // table
        passwordTable = NeonTableView<PasswordModel, PasswordTableViewCell>(
            objects: passwords, heightForRows: view.frame.height * 0.08, style: .plain
        )
        passwordTable?.backgroundColor = .styledWhite1

        // dis select
        passwordTable?.didSelect = { [self] object, indexPath in
            let selectedPasswordVC = SelectedPasswordsVC()
            selectedPasswordVC.password = object
            self.present(destinationVC: selectedPasswordVC, slideDirection: .right)
            
        }
        passwordTable?.trailingSwipeActions = [
            SwipeAction(title: "Delete", color: .styledRed) { [self] pass, indexPath in
                deletePassword(password: pass)
                fetchPasswords()
                passwordTable?.objects = filteredPass
            }
        ]
    }
    
    
    func fetchPasswords() {

        FirebaseService.shared.fetchPasswords { [self] passwordsData in
            if let passwordsData = passwordsData {
                // Firebase'den başarıyla alınan şifreler
                passwords = passwordsData
                filteredPass = passwordsData
                setupTableUI()
            } else {
                // Hata durumu
                print("Error: Failed to fetch passwords from Firebase")
            }
        }
  }
    
    func deletePassword(password: PasswordModel) {
        
        FirebaseService.shared.deletePassword(password: password, completion: { [self] error in
            if let error = error {
                // Error
                getAlert(title: "Error", message: "An error occurred while deleting password")
                
            } else {
                getAlert(title: "Success", message: "Password deleted successfully.")
                // Success
            }
            
        })
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
            filteredPass = passwords
        }
        else{
            filteredPass = passwords.filter { pass in
                return pass.accountName.lowercased().contains(searchText.lowercased())
                
            }
        }
        passwordTable?.objects = filteredPass

    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    // MARK: - OBJC FUNCTIONS
    
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    
    @objc func selectedPasswordVC() {
        
        let editVC = SelectedPasswordsVC()

        if selectedPassIndex != nil {
            editVC.password = passwords[selectedPassIndex!]
        }
     
        self.present(destinationVC: editVC, slideDirection: .right)

    }
    
    
}

