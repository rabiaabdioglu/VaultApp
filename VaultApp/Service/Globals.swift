//
//  Globals.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 7.04.2024.
//

import Foundation
import NeonSDK

final class DataManager {
    // Singleton instance
    static let shared = DataManager()
    
    var userID = AuthManager.currentUserID
    
    // Shared data arrays
    var albums: [AlbumModel] = []
    var selectedAlbumPhotos : [PhotoModel] = []
    
    var passwords: [PasswordModel] = []
    
    var notes: [NoteModel] =  []
}
