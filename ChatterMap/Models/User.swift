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
    var postedNotes: [String]
    var savedNotes: [String]
    
    init(id: String = "", username: String = "", postedNotes: [String] = [], savedNotes: [String] = []) {
        self.id = id
        self.username = username
        self.postedNotes = postedNotes
        self.savedNotes = savedNotes
    }
    
    func setId(_ id: String) {
        self.id = id
    }
    
    func setUsername(_ username: String) {
        self.username = username
    }
    
    func updateUser(id: String, username: String) {
        self.id = id
        self.username = username
    }
}
