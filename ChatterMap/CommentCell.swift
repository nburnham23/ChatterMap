//
//  CommentCell.swift
//  ChatterMap
//
//  Created by jared on 11/11/25.
//

import SwiftUI

struct CommentCell: View {
    let comment: Comment
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(comment.userID)
                .font(.caption)
                .foregroundStyle(.gray)
            Text(comment.commentText)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
