//
//  User.swift
//  ChatterMap
//
//  Created by user285571 on 10/22/25.
//

import Foundation

class User: Identifiable, Codable, ObservableObject {
    var id: String
    var username: String
    var notes: [String]
<<<<<<< HEAD
=======
    var savedNotes: [Note]
    
    init(){
        self.id = ""
        self.username = ""
        self.notes = []
        self.savedNotes = []
    }
    
    func setId(_ id: String){
        self.id = id
    }
    func setUsername(_ username: String){
        self.username = username
    }
>>>>>>> main
}
