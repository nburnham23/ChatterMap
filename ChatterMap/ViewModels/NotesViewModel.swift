//
//  NotesViewModel.swift
//  ChatterMap
//
//  Created by jared on 10/29/25.
//

import SwiftUI
import FirebaseFirestore
import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNote: Note? = nil
    private let firestoreService = FirestoreService()
    
    private var db = Firestore.firestore()
    
    func fetchNotes(){
        let oneWeekAgo = Date.now.addingTimeInterval(-604800)
        
        db.collection("Notes").whereField("timestamp", isGreaterThan: oneWeekAgo)
            .addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("No notes")
                return
            }
            self.notes = documents.map{ (queryDocumentSnapshot) -> Note in
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? String ?? ""
                let userID = data["userID"] as? String ?? ""
                let noteText = data["noteText"] as? String ?? ""
                let voteCount = data["voteCount"] as? Int ?? 0
                let latitude = data["latitude"] as? Double ?? 0.0
                let longitude = data["longitude"] as? Double ?? 0.0
                let timestamp = data["timestamp"] as? Date ?? Date()
                
                return Note(id: id, userID: userID, noteText: noteText, voteCount: voteCount, latitude: latitude, longitude: longitude, timestamp: timestamp)
            }
        }
    }
    
    
    func loadNotes() async {
        self.notes = await firestoreService.getAllNotes()
    }

    
}
