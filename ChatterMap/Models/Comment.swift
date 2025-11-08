//
//  Note.swift
//  ChatterMap
//
//  Created by user285571 on 10/22/25.
//

import Foundation

struct Comment: Identifiable, Codable {
    var id: String
    var parentNoteID: String
    var userID: String
    var commentText: String
    var voteCount: Int
}
