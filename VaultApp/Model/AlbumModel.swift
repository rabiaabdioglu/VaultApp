//
//  AlbumModel.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 7.04.2024.
//

import Foundation

struct AlbumModel : Codable{
    var id: UUID
    var albumName: String
    var albumCoverPhotoURL: String
    var photos: [PhotoModel]
    var photosCount: Int

}
struct PhotoModel: Codable{
    var id : UUID
    var photoURL: String
    var isSelected = false
 
}

enum PhotoError: Error {
    case imageCompressionFailed
    case uploadFailed
    case saveToAlbumFailed
}

/** ilk ikissi note ve pass için aynı daha sonra bir ayrıma gidiyor
 
 
 users (collection)
    |
    --- userID (document)
          |
          --- albums (subcollection)
                |
                --- albumID (document)
                      |
                      --- albumName: "My Album"
                      |
                      --- albumCoverPhotoURL: "coverPhotoURL"
                      |
                      --- photos (subcollection)
                            |
                            --- photoID (document)
                                  |
                                  --- photoURL: "https://example.com/photo.jpg"

 
 
 */
