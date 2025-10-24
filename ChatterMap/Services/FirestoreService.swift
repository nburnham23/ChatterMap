//
//  FirestoreService.swift
//  ChatterMap
//  ALL Database Getters/Setters
//  Created by user285571 on 10/22/25.
//

import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    // Create User
    func createUser(user: User) async {
        do {
            try await db.collection("Users").document(user.id).setData([
                "id": user.id,
                "username": user.username,
                "notes": user.notes
            ])
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    // Get User
    func getUser(user: User) async {
        let docRef = db.collection("Users").document(user.id)
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
    // Create Note
    func createNote(note: Note) async {
        do {
            try await db.collection("Notes").document(note.id).setData([
                "id": note.id,
                "userID": note.userID,
                "noteText": note.noteText,
                "voteCount": note.voteCount,
                "comments": note.comments,
            ])
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    func getNote(note: Note) async {
        let docRef = db.collection("Notes").document(note.id)
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
    
}
