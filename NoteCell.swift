//
//  NoteCell.swift
//  ChatterMap
//
//  Created by jared on 11/11/25.
//

import SwiftUI

struct NoteCell: View {
    let note: Note
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.userID)
                .font(.caption)
                .foregroundStyle(.gray)
            Text(note.noteText)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
