//
//  User.swift
//  ChatterMap
//
//  Created by user285571 on 10/22/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var notes: [String]
}
