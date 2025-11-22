//
//  CommentCell.swift
//  ChatterMap
//
//  Created by jared on 11/11/25.
//

import SwiftUI

struct CommentCell: View {
    let comment: Comment
    @State private var user: User? = nil
    let firestoreService = FirestoreService()
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if let user = user {
                Text(user.username)
                    .font(.caption)
                    .foregroundStyle(.gray)
            } else{
                Text("Phantom user")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Text(comment.commentText)
                .font(.body)
        }
        .onAppear {
            Task{
                self.user = await firestoreService.getUser(withId: comment.userID)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
