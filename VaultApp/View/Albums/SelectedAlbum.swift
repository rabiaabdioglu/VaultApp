//
//  SelectedAlbum.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//
// This class represents the view controller for the selected album, allowing users to view and manage photos within the album.

import Foundation
import UIKit
import NeonSDK

class SelectedAlbumVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var selectedAlbum : AlbumModel? = nil
    var selectedPhotosIDS : [UUID] = []
    var isDeletingActive = false

    // MARK: UI Components
    var photosCollectionView: PhotoCollectionView!
    var addNewAlbumViewStack = NeonVStack()
    var textFieldView = CustomTextFieldWithShadow()
    let progressView = CustomProgressStackView()
    let deleteButton = CustomButton(title: "Delete")
    let selectedPhotoCountLabel = UILabel()
    let backgroundView = UIView()
    let navigationView = NavigationView(leftImageName: "leftArrow", title: "Edit Account", rightImageName: "trash")
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        refreshPhotos()
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        setupCollectionView()
        setupUI()
        // Hide photo collection view if no album is selected,
        //otherwise hide addNewAlbumViewStack and fetch photos.
        if  selectedAlbum == nil  {
            photosCollectionView.isHidden = true
            
        } else {
            addNewAlbumViewStack.isHidden = true
            fetchPhotos()
        }
        // Observers for handling image picker and photo save completion.
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpenImagePicker), name: NSNotification.Name("openImagePicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(photoSaveCompleted), name: NSNotification.Name("photoSaveCompleted"), object: nil)
        
        
    }
    
    
    // MARK: - SETUP UI
    func setupUI() {
        // Navigation view setup
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(selectDeletionPhotos), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        // Background view setup
        backgroundView.backgroundColor = .styledWhite1
        backgroundView.layer.cornerRadius = 30
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.86)
            make.width.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(10)
        }
        // Right top label "0 selected"
        backgroundView.addSubview(selectedPhotoCountLabel)
        selectedPhotoCountLabel.text = "\(selectedPhotosIDS.count) selected"
        selectedPhotoCountLabel.textColor = .styledGray
        selectedPhotoCountLabel.font = Font.custom(size: 14, fontWeight: .Light)
        selectedPhotoCountLabel.textAlignment = .right
        selectedPhotoCountLabel.isHidden = true
        selectedPhotoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).inset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(20)
        }
        
        // Photo collection view setup
        backgroundView.addSubview(photosCollectionView!)
        photosCollectionView!.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        backgroundView.bringSubviewToFront(selectedPhotoCountLabel)

        deleteButton.button.backgroundColor = .styledWhite2
        deleteButton.button.setTitleColor(.styledRed2, for: .normal)
        deleteButton.button.addTarget(self, action: #selector(deleteSelectedPhotos), for: .touchUpInside)
        deleteButton.isHidden = true
        backgroundView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(50)
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-70)
            make.centerX.equalToSuperview()
        }
        // AddNewAlbumView setup with text field and buttons
        addNewAlbumViewStack = NeonVStack(width: view.frame.width , block: { addNewAlbumViewStack in
            // Textfield setup
            textFieldView.setPlaceholder("Album Name")
            addNewAlbumViewStack.addSubview(textFieldView)
            textFieldView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.4)
            }
            // Buttons setup
            let buttonsHStack = NeonHStack(height: 100 , block: { buttonsHStack in
                // Cancel button
                let cancelButton = CustomButton(title: "Cancel")
                cancelButton.button.backgroundColor = .styledWhite1
                cancelButton.button.setTitleColor(.styledBlack1, for: .normal)
                cancelButton.button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
                buttonsHStack.addSubview(cancelButton)
                cancelButton.snp.makeConstraints { make in
                    make.width.equalToSuperview().multipliedBy(0.45)
                    make.height.equalToSuperview()
                }
                // Save button
                let saveButton = CustomButton(title: "Save")
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
            addNewAlbumViewStack.addSubview(buttonsHStack)
            buttonsHStack.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.4)
            }
        })
        addNewAlbumViewStack.alignment = .center
        backgroundView.addSubview(addNewAlbumViewStack)
        addNewAlbumViewStack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        backgroundView.bringSubviewToFront(addNewAlbumViewStack)
        // Progress View Stack
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        progressView.isHidden = true
        view.bringSubviewToFront(progressView)
    }
    
    // MARK: Setup Collection View
    func setupCollectionView(){
        // Collection View setup
        photosCollectionView = PhotoCollectionView(photos: selectedAlbum?.photos ?? [])
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchPhotos), for: .valueChanged)
        photosCollectionView!.refreshControl = refreshControl
    }
    
    
    // MARK: - OBJC Functions
    
    // save  new album to Firebase and updated UI changes
    @objc  func saveButtonTapped() {
        navigationView.rightButton.isHidden = false
        navigationView.titleLabel.text = textFieldView.getText()
        addNewAlbumViewStack.isHidden = true
        photosCollectionView.isHidden = false
        let newAlbum = AlbumModel(id: UUID(), albumName: textFieldView.getText()! , albumCoverPhotoURL: "", photos: [], photosCount: 0)
        FirebaseService.shared.saveAlbum(newAlbum)
        self.selectedAlbum = newAlbum
    }
    // MARK: Deletion
    // Function to handle the deletion of photos
    @objc func selectDeletionPhotos(){
        // deleting active for photos selectable
        isDeletingActive.toggle()
        selectedPhotosIDS = []
        if isDeletingActive{
            
            selectedPhotoCountLabel.isHidden = false
            deleteButton.isHidden = false

            photosCollectionView.snp.removeConstraints()
            photosCollectionView!.snp.makeConstraints { make in
                make.top.equalTo(selectedPhotoCountLabel.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                self.photosCollectionView.layoutIfNeeded()
                self.backgroundView.layoutIfNeeded()
            }

        

            // Change the didSelect actions when isDeletingActive is true
            photosCollectionView.didSelect = { [self] object, indexPath in
                // Change the UI of the selected cell
                if let cell = photosCollectionView.cellForItem(at: indexPath) as? CollectionViewPhotoCell {
                    cell.photo?.isSelected.toggle()
                    if cell.photo?.isSelected == true {
                        selectedPhotosIDS.append(cell.photo!.id)
                    }
                    else{
                        selectedPhotosIDS.remove(cell.photo!.id)
                    }
                    cell.configure(with: cell.photo!)
                }
                selectedPhotoCountLabel.text = "\(selectedPhotosIDS.count) selected"
                
            }
            
      
        }
        else{
            
            selectedPhotoCountLabel.isHidden = true
            deleteButton.isHidden = true
            photosCollectionView.snp.removeConstraints()

            photosCollectionView!.snp.makeConstraints { make in
                make.top.equalTo(backgroundView.snp.top).offset(20)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                self.photosCollectionView.layoutIfNeeded()
                self.backgroundView.layoutIfNeeded()
            }
            
            //  set the default UI for all cells
            for indexPath in photosCollectionView.indexPathsForVisibleItems {
                if let cell = photosCollectionView.cellForItem(at: indexPath) as? CollectionViewPhotoCell {
                    cell.photo?.isSelected = false
                    cell.configure(with: cell.photo!)
                }
            }
  
            // Set default empty didSelect action
            photosCollectionView.didSelect = { object, indexPath in
                print(indexPath.item)
            }
        }
    }
    @objc func deleteSelectedPhotos() {
        
        FirebaseService.shared.deleteSelectedPhotos(album: selectedAlbum!, photoIDs: selectedPhotosIDS) { [self] error in
            if let error = error {
                // Error
                getAlert(title: "Error", message: "An error occurred while deleting photos")
                
            } else {
                getAlert(title: "Success", message: "Photos deleted successfully.")
                // Success
                selectDeletionPhotos()
                fetchPhotos()

                
            }
        }
    }

    // Refresh photos
    @objc func refreshPhotos() {
        photosCollectionView!.refreshControl?.beginRefreshing()
        if let photos = selectedAlbum?.photos {
            photosCollectionView.objects = photos
            photosCollectionView.reloadData()
        }
        photosCollectionView!.refreshControl?.endRefreshing()
    }

    // Notification if photo saved completly hide progress view and fetch photos
    @objc func photoSaveCompleted(){
        fetchPhotos()
        progressView.isHidden = true

    }
    
    @objc func fetchPhotos() {
        // Fetch all photos for selected album
        if let selectedAlbum = selectedAlbum {
            FirebaseService.shared.fetchPhotos(album: selectedAlbum) { [self] photos in
                if let photos = photos {
                    DispatchQueue.main.async {
                        self.selectedAlbum?.photos = photos
                        self.refreshPhotos()
                    }
                } else {
                    getAlert(title: "Error", message: "Failed to retrieve photos for \(selectedAlbum.albumName) album")
                    goBack()
                }
            }
        }
        
    }
    // Go back
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    
    // MARK: Image Picker setup

    
    // Open Image picker
    @objc private func handleOpenImagePicker() {
        progressView.isHidden = false
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if let album = selectedAlbum {
                FirebaseService.shared.savePhoto(album, image: selectedImage){ [self] error in
                    if let error = error {
                        // Error
                        getAlert(title: "Error", message: "An error occurred while saving photo")

                    } else {
                        getAlert(title: "Success", message: "Photo saved successfully")
                   
                        // Success
                        fetchPhotos()

                    }
                }
                
            }
            dismiss(animated: true, completion: nil)
        }}
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        progressView.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    func getAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - Collection View Overrides

final class PhotoCollectionView : NeonCollectionView<PhotoModel , CollectionViewPhotoCell> {

    convenience init(photos: [PhotoModel]) {
        self.init(
            objects: photos,
            itemsPerRow: 3,
            leftPadding: 5,
            rightPadding: 5,
            horizontalItemSpacing: 5,
            verticalItemSpacing: 5
        )
        self.backgroundColor = .clear
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewPhotoCell.identifier, for: indexPath) as! CollectionViewPhotoCell
        let plusCell = PhotoModel(id: UUID(), photoURL: "firstCellPlus")
        // first cell must plusCell
        if indexPath.item == 0 {
            cell.configure(with: plusCell)
        } else {
            let photo = objects[indexPath.item - 1]
            cell.configure(with: photo)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // + 1 because first cell is plusCell
        return objects.count + 1
    }

 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            let object = objects[indexPath.item - 1]
            didSelect?(object, indexPath)
        } else {
            // plus cell action
            NeonNotificationCenter.post(id: "openImagePicker")
        }
    }


    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size.width / 3.2
        return CGSize(width: size, height: size )
    }
    
}
