//
//  FirebaseService.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 8.04.2024.
//

// FirebaseService.swift

import Foundation
import NeonSDK
import FirebaseStorage
import UIKit
class FirebaseService {
    
    static let shared = FirebaseService()
    
    
    // MARK: - Save Note
    
    func saveNote(_ newNote: NoteModel, completion: @escaping (Error?) -> Void) {
        FirestoreManager.setDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "notes"),
            .document(name: "\(newNote.id)"),
        ], object: newNote)
        completion(nil)
    }
    
    // MARK: - Fetch Notes
    
    func fetchNotes(completion: @escaping ([NoteModel]?) -> Void) {
        var notesData: [NoteModel] = []
        FirestoreManager.getDocuments(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "notes"),
        ], objectType: NoteModel.self) {  objects in
            if let note = objects as? NoteModel {
                notesData.append(note)
                
            } else {
                print("Error: Failed to retrieve user data")
            }
        }
    isLastFetched: {
        completion(notesData)
        
    }
        
    }
    func updateNote(updatedNote: NoteModel, completion: @escaping (Error?) -> Void){
        FirestoreManager.updateDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "notes"),
            .document(name: updatedNote.id.uuidString)
        ], fields: [
            "noteTitle" : updatedNote.noteTitle,
            "noteContent" : updatedNote.noteContent
        ])
        
        
    }
    func deleteNote(note: NoteModel, completion: @escaping (Error?) -> Void){
        FirestoreManager.deleteDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "notes"),
            .document(name: note.id.uuidString)
         
        ])
        completion(nil)
    }
    // MARK: - Save Password
    
    func savePassword(_ newPassword: PasswordModel) {
        FirestoreManager.setDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "passwords"),
            .document(name: "\(newPassword.id)"),
        ], object: newPassword)
    }
    
    // MARK: - Fetch Passwords
    
    func fetchPasswords(completion: @escaping ([PasswordModel]?) -> Void) {
        var passwordsData: [PasswordModel] = []
        FirestoreManager.getDocuments(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "passwords"),
        ], objectType: PasswordModel.self) {  objects in
            if let password = objects as? PasswordModel {
                passwordsData.append(password)
                
            } else {
                print("Error: Failed to retrieve user data")
            }
        }
    isLastFetched: {
        completion(passwordsData)
        
    }
        
    } 
    func updatePassword(updatedPassword: PasswordModel, completion: @escaping (Error?) -> Void){
        FirestoreManager.updateDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "passwords"),
            .document(name: updatedPassword.id.uuidString)
        ], fields: [
            "accountName" : updatedPassword.accountName,
            "iconName" : updatedPassword.iconName,
            "login" : updatedPassword.login,
            "password" : updatedPassword.password,
            "website" : updatedPassword.website
        ])
        completion(nil)
        
    }
    func deletePassword(password: PasswordModel, completion: @escaping (Error?) -> Void){
        FirestoreManager.deleteDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "passwords"),
            .document(name: password.id.uuidString)
         
        ])
        completion(nil)
    }
    
    
    
    
    // MARK: - New Album
    func saveAlbum(_ newAlbum: AlbumModel) {
        FirestoreManager.setDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "albums"),
            .document(name: "\(newAlbum.id)"),
        ], fields: [
            "id" : newAlbum.id.uuidString,
            "albumName" : newAlbum.albumName,
            "albumCoverPhotoURL": newAlbum.albumCoverPhotoURL,
            "photosCount" : newAlbum.photosCount
        ])
        
        
    }
    
    
    // MARK: - Save Photo To album
    
    func savePhoto(_ album: AlbumModel, image: UIImage, completion: @escaping (Error?) -> Void) {
        guard let compressedImageData = compressImage(image, compressionQuality: 0.3) else {
            completion(PhotoError.imageCompressionFailed)
            return
        }
        
        let uiImage = UIImage(data: compressedImageData)
        let newPhotoID = UUID()
        let albumID = album.id.uuidString
        uploadPhotoToStorage(uiImage, newPhotoID: newPhotoID.uuidString, albumID: albumID) { [self] downloadURL in
            guard let downloadURL = downloadURL else {
                completion(PhotoError.uploadFailed)
                return
            }
            
            let newPhoto = PhotoModel(id: newPhotoID, photoURL: downloadURL)
            
            savePhotoToAlbum(albumID, newPhoto: newPhoto) { error in
                if let error = error {
                    completion(error)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name("photoSaveCompleted"), object: nil)
                    completion(nil)
                }
            }
        }
    }
    
    
    // Fotoğrafı sıkıştıran yardımcı fonksiyon
    func compressImage(_ image: UIImage, compressionQuality: CGFloat) -> Data? {
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        var newCompressionQuality = compressionQuality
        
        while let data = imageData, data.count > 1 * 1024 * 1024, newCompressionQuality > 0 {
            newCompressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: newCompressionQuality)
        }
        
        return imageData
    }
    
    // Resmi depolamaya yükleyen fonksiyon
    func uploadPhotoToStorage(_  image: UIImage?, newPhotoID: String , albumID: String, completion: @escaping (String?) -> Void) {
        guard let uiImage = image else {
            completion(nil)
            return
        }
        let storageRef = "userPhotos/\(DataManager.shared.userID!)/albums/\(albumID)/\(newPhotoID)"
        
        StorageManager.uploadImage(image: uiImage, storageRef: storageRef) { downloadURL in
            completion(downloadURL)
            
        }
        
    }
    
    // Albüm belgesini güncelleyen ve Firestore'a kaydeden fonksiyon
    func savePhotoToAlbum(_ albumID: String, newPhoto: PhotoModel, completion: @escaping (Error?) -> Void) {
        FirestoreManager.setDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "albums"),
            .document(name: albumID),
            .collection(name: "photos"),
            .document(name: newPhoto.id.uuidString)
        ],  fields: [
            "id" : newPhoto.id.uuidString,
            "photoURL" : newPhoto.photoURL
        ])
        
        
        completion(nil)
    }
    
    func updateAlbum(album : AlbumModel, photoURL: String, photoCount: Int){
        //      lazy var coverPhotoURL = album.albumCoverPhotoURL
        //
        //        if coverPhotoURL == "" {
        //            coverPhotoURL = photoURL
        //        }
        //
        FirestoreManager.updateDocument(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "albums"),
            .document(name: album.id.uuidString)
        ], fields: [
            "albumCoverPhotoURL" : photoURL,
            "photosCount" : photoCount
        ])
        
    }
    
    // MARK: - Fetch Albums
    
    func fetchAlbums(completion: @escaping ([AlbumModel]?) -> Void) {
        var albumData: [AlbumModel] = []
        FirestoreManager.getDocuments(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "albums"),
        ], completion: { documentID, documentData  in
            if let idString = documentData["id"] as? String,
               let id = UUID(uuidString: idString),
               let albumName = documentData["albumName"] as? String,
               let albumCoverPhotoURL = documentData["albumCoverPhotoURL"] as? String,
               let photosCount = documentData["photosCount"] as? Int
            {
                
                let album = AlbumModel(id: id,
                                       albumName: albumName,
                                       albumCoverPhotoURL: albumCoverPhotoURL,
                                       photos: [],
                                       photosCount: photosCount)
                
                albumData.append(album)
                
            } else {
                print("Error: Failed to parse album data")
            }
            
        },isLastFetched: {
            DataManager.shared.albums = albumData
            completion(albumData)
            
        }
        )
    }
    
    func fetchPhotos(album: AlbumModel , completion: @escaping ([PhotoModel]?) -> Void) {
        var photosData: [PhotoModel] = []
        lazy var albumID = album.id.uuidString
        FirestoreManager.getDocuments(path: [
            .collection(name: "users"),
            .document(name: DataManager.shared.userID!),
            .collection(name: "albums"),
            .document(name: albumID),
            .collection(name: "photos"),
        ], completion: { documentID, documentData  in
            if let idString = documentData["id"] as? String,
               let id = UUID(uuidString: idString),
               let photoURL = documentData["photoURL"] as? String{
                
                let photo = PhotoModel(id: id, photoURL: photoURL)
                photosData.append(photo)
            }
            else {
                print("Error: Failed to retrieve user data")
            }
            
        },isLastFetched: { [self] in
            var photoURL = album.albumCoverPhotoURL
            if photoURL == "" {
                photoURL = photosData.first!.photoURL
            }
            updateAlbum(album: album, photoURL: photoURL , photoCount: photosData.count)
            completion(photosData)
            
        })
        
    }
    
    func deleteSelectedPhotos(album: AlbumModel, photoIDs: [UUID], completion: @escaping (Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        for photoID in photoIDs {
            // Delete document from Firestore
            FirestoreManager.deleteDocument(path: [
                .collection(name: "users"),
                .document(name: DataManager.shared.userID!),
                .collection(name: "albums"),
                .document(name: album.id.uuidString),
                .collection(name: "photos"),
                .document(name: photoID.uuidString)
            ])
            //         Delete photos from Cloud Storage
            let photoRef = storageRef.child("userPhotos/\(DataManager.shared.userID!)/albums/\(album.id.uuidString)/\(photoID.uuidString).png")
            photoRef.delete { error in
                if let error = error {
                    print("Error deleting file: \(error)")
                    completion(error)
                } else {
                    
                    print("File deleted successfully")
                }
                
            }
            completion(nil)
        }
    }
    
    // burdahata var sanırım içindekiler var diye silme yapmıyor.
    
    
    func deleteAlbum(album: AlbumModel, completion: @escaping (Error?) -> Void) {
        var photoIDs: [UUID]?
        
        fetchPhotos(album: album) { [self] photos in
            if let albumPhotos = photos {
                photoIDs = albumPhotos.map { $0.id }
                
                // delete all photos first then delete album
                deleteSelectedPhotos(album: album, photoIDs: photoIDs ?? []) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        // Album deletion
                        FirestoreManager.deleteDocument(path: [
                            .collection(name: "users"),
                            .document(name: DataManager.shared.userID!),
                            .collection(name: "albums"),
                            .document(name: album.id.uuidString)
                        ])
                        completion(nil)
                        
                        
                    }
                }
            }
            
        }
        if photoIDs == nil{
            // Empty album
            FirestoreManager.deleteDocument(path: [
                .collection(name: "users"),
                .document(name: DataManager.shared.userID!),
                .collection(name: "albums"),
                .document(name: album.id.uuidString)
            ])
            completion(nil)
        }
    }
    
}
