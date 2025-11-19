//
//  Note.swift
//  ChatterMap
//
//  Created by user285571 on 10/22/25.
//

import Foundation

struct Note: Identifiable, Codable {
    var id: String
    var userID: String
    var noteText: String
    var voteCount: Int
    var latitude: Double
    var longitude: Double
    var timestamp: Date?
}
