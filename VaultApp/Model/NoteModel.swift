//
//  NoteModel.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 7.04.2024.
//

import Foundation

struct NoteModel: Codable{
    let id : UUID
    let noteTitle: String
    let noteContent: String
    
    
       static func splitNoteContent(_ content: String) -> (title: String, content: String) {
           guard let firstNewLineIndex = content.firstIndex(of: "\n") else {
               return (content, "") // Eğer alt satıra geçiş yoksa, başlık olarak tüm içeriği alırız
           }
           
           let title = content[..<firstNewLineIndex].trimmingCharacters(in: .whitespacesAndNewlines)
           let remainingContent = content[content.index(after: firstNewLineIndex)...]
           
           return (String(title), String(remainingContent))
       }

}
/**
 
 users (collection)
    |
    --- userID (document)
          |
          --- notes (subcollection)
                |
                --- noteID (document)
                      |
                      --- noteTitle: "My Note Title"
                      |
                      --- noteContent: "This is the content of my note."
 
 
 */
