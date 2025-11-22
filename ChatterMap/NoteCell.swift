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
    @State private var user: User? = nil
    let firestoreService = FirestoreService()
    
    init(note: Note, @ViewBuilder trailing: () -> Trailing = {EmptyView()}) {
        self.note = note
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                if let user = user{
                    Text(user.username)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }else{
                    Text("Phantom user")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Text(note.noteText)
                    .font(.body)
            }
            
            Spacer()

            trailing
        }
        .onAppear{
            Task{
                self.user = await firestoreService.getUser(withId: note.userID)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
