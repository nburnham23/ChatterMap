//
//  NoteCell.swift
//  ChatterMap
//
//  Created by jared on 11/11/25.
//

import SwiftUI

struct NoteCell<Trailing: View>: View {
    let note: Note
    let trailing: Trailing
    
    init(note: Note, @ViewBuilder trailing: () -> Trailing = {EmptyView()}) {
        self.note = note
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(note.userID)
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text(note.noteText)
                    .font(.body)
            }
            
            Spacer()

            trailing
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
