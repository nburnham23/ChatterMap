//
//  CommentsViewModel.swift
//  ChatterMap
//
//  Created by Noah Burnham on 11/21/25.
//

import SwiftUI
import FirebaseFirestore
import Foundation

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var selectedNote: Note? = nil
    private let firestoreService = FirestoreService()
    
    private var db = Firestore.firestore()
    
    func fetchComments(){
        db.collection("Comments").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("No comments")
                return
            }
            self.comments = documents.map{ (queryDocumentSnapshot) -> Comment in
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? String ?? ""
                let parentNoteID = data["parentNoteID"] as? String ?? ""
                let userID = data["userID"] as? String ?? ""
                let commentText = data["commentText"] as? String ?? ""
                let voteCount = data["voteCount"] as? Int ?? 0
                
                return Comment(id: id, parentNoteID: parentNoteID, userID: userID, commentText: commentText, voteCount: voteCount)
            }
        }
    }
}
