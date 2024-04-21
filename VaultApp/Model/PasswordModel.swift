//
//  PasswordModel.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 5.04.2024.
//

import Foundation

struct PasswordModel : Codable{
    let id: UUID
    let iconName: String
    let accountName: String
    let login: String
    let password: String
    let website: String
}
/**
 
 
 users (collection)
    |
    --- userID (document)
         |
         --- passwords (subcollection)
               |
               --- passwordID (document)
                     |
                     --- accountName: "My Account"
                     |
                     --- login: "myusername"
                     |
                     --- password: "mypassword"
                     |
                     --- website: "https://example.com"

 
 */
