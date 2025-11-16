//
//  Route.swift
//  ChatterMap
//
//  Created by jared on 11/14/25.
//

import Foundation

struct Route: Identifiable, Codable {
    var id: String
    var routeName: String
    var includedNotes: [String]
    var userID: String
}

extension Route {
    static let preview = Route(
        id: "testID12345",
        routeName: "testRoute",
        includedNotes: [],
        userID: "exampleUser"
    )
}
