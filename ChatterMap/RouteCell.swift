//
//  NoteCell.swift
//  ChatterMap
//
//  Created by jared on 11/11/25.
//

import SwiftUI

struct RouteCell: View {
    let route: Route
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(route.userID)
                .font(.caption)
                .foregroundStyle(.gray)
            Text(route.id)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
