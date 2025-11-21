//  FirestoreService.swift
//  ChatterMap
//  ALL Database Getters/Setters
//  Created by user285571 on 10/22/25.
//

import FirebaseCore
import FirebaseFirestore

class FirestoreService {
    let db = Firestore.firestore()
    
    func listenToAllRoutes(completion: @escaping ([Route]) -> Void) -> ListenerRegistration {
        return db.collection("Routes").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            let routes = documents.compactMap { doc in
                try? doc.data(as: Route.self)
            }
            completion(routes)
            }
    }
    
    // USER FUNCTIONS
    // Create User
    func createUser(user: User) async {
        do {
            try await db.collection("Users").document(user.id).setData([
                "id": user.id,
                "username": user.username,
                "postedNotes": user.postedNotes,
                "savedNotes": user.savedNotes
            ])
            print("User successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func saveNoteToUser(userID: String, noteID: String) async throws {
        let userRef = db.collection("Users").document(userID)
        try await userRef.updateData([
            "savedNotes": FieldValue.arrayUnion([noteID])
        ])
    }
    
    func unsaveNoteToUser(userID: String, noteID: String) async throws {
        let userRef = db.collection("Users").document(userID)
        try await userRef.updateData([
            "savedNotes": FieldValue.arrayRemove([noteID])
        ])
    }
    
    func getUser(withId id: String) async -> User? {
        let docRef = db.collection("Users").document(id)
        do {
            let document = try await docRef.getDocument()
            if let user = try? document.data(as: User.self) {
                return user
            } else {
                print("Failed to decode user data")
                return nil
            }
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    
    func getUserById(uid: String) async -> User? {
        do {
            let document = try await db.collection("Users").document(uid).getDocument()
            return try document.data(as: User.self)
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    

    func createNote(note: Note) async {
        do {
            try await db.collection("Notes").document(note.id).setData([
                "id": note.id,
                "userID": note.userID,
                "noteText": note.noteText,
                "voteCount": note.voteCount,
                "latitude": note.latitude,
                "longitude": note.longitude,
                "timestamp": note.timestamp
            ])
            print("Note successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    // delete note
    func deleteNote(noteID: String) async {
        do {
            // delete the note
            try await db.collection("Notes").document(noteID).delete()
            print("Note deleted from Notes collection.")
            // remove note from all savedNotes
            let usersSnapshot = try await db.collection("Users").getDocuments()
            for doc in usersSnapshot.documents {
                var savedNotes = doc.data()["savedNotes"] as? [String] ?? []
                if savedNotes.contains(noteID) {
                    savedNotes.removeAll { $0 == noteID }
                    try await db.collection("Users").document(doc.documentID).updateData([
                        "savedNotes": savedNotes
                    ])
                    print("Removed note \(noteID) from user \(doc.documentID)'s savedNotes")
                }
            }
            print("Cleanup complete.")
        } catch {
            print("Error deleting note everywhere: \(error)")
        }
    }
    
    
    func getNote(id: String) async -> Note? {
        do {
            let document = try await db.collection("Notes").document(id).getDocument()
            return try document.data(as: Note.self)
        } catch {
            print("Error fetching note: \(error)")
            return nil
        }
    }
    
    func getPostedNotesByUser(parentUserID: String) async -> [Note] {
        do {
            let snapshot = try await db.collection("Notes")
                .whereField("userID", isEqualTo: parentUserID)
                .getDocuments()
            return snapshot.documents.compactMap { doc in
                try? doc.data(as: Note.self)
            }
        } catch {
            print("Error fetching notes: \(error)")
            return []
        }
    }
    
    func getSavedNotesByUser(parentUserID: String) async -> [Note] {
        do {
            let userDoc = try await db.collection("Users").document(parentUserID).getDocument()
            
            let userData = try userDoc.data(as: User.self)
            
            var savedNotes: [Note] = []
            for noteID in userData.savedNotes {
                if let note = await getNote(id: noteID) {
                    savedNotes.append(note)
                }
            }
            return savedNotes
            
        } catch {
            print("Error fetching saved notes for user \(parentUserID): \(error)")
            return []
        }
    }
    
    func getAllNotes() async -> [Note] {
        do {
            // TODO: this aint working
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            
            let snapshot = try await db.collection("Notes").whereField("timestamp", isLessThan: oneWeekAgo)
                .getDocuments()
            let notes = snapshot.documents.compactMap { document in
                try? document.data(as: Note.self)
            }
            return notes
        } catch {
            print("Error fetching notes: \(error)")
            return []
        }
    }
     
    func updateVoteCount(note: Note) async {
        do {
            try await db.collection("Notes").document(note.id).updateData([
                "voteCount": note.voteCount,
            ])
            print("vote count successfully updated")
        } catch {
            print("Error updating vote count: \(error)")
        }
    }

    func createComment(comment: Comment) async {
        do {
            try await db.collection("Comments").document(comment.id).setData([
                "id": comment.id,
                "userID": comment.userID,
                "parentNoteID": comment.parentNoteID,
                "commentText": comment.commentText,
                "voteCount": comment.voteCount,
            ])
            print("Comment successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func getCommentsByNote(parentNoteID: String) async -> [Comment] {
        do {
            let snapshot = try await db.collection("Comments")
                .whereField("parentNoteID", isEqualTo: parentNoteID)
                .getDocuments()

            return snapshot.documents.compactMap { doc in
                try? doc.data(as: Comment.self)
            }
        } catch {
            print("Error getting comments: \(error)")
            return []
        }
    }
    

    func getAllRoutes() async -> [Route] {
        do {
            let snapshot = try await db.collection("Routes").getDocuments()
            let routes = snapshot.documents.compactMap { document in
                try? document.data(as: Route.self)
            }
            return routes
        } catch {
            print("Error fetching routes: \(error)")
            return []
        }
    }
    
    func createRoute(route: Route) async {
        do {
            try await db.collection("Routes").document(route.id).setData([
                "id": route.id,
                "routeName": route.routeName,
                "includedNotes": route.includedNotes,
                "userID": route.userID,
            ])
            print("Route successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    

    // ========
    // NEW CODE
    // ========
    func updateCommentVote(commentID: String, newCount: Int) async {
        do {
            try await db.collection("Comments").document(commentID).updateData([
                "voteCount": newCount
            ])
            print("Comment vote updated")
        } catch {
            print("Error updating comment vote: \(error)")
        }
    }

    // COMMENT TIMESTAMP
    func addTimestampToComment(commentID: String, timestamp: Date) async {
        do {
            try await db.collection("Comments").document(commentID).updateData([
                "timestamp": Timestamp(date: timestamp)
            ])
        } catch {
            print("Error adding timestamp: \(error)")
        }
    }

    // NOTE TIMESTAMP
    func addTimestampToNote(noteID: String, timestamp: Date) async {
        do {
            try await db.collection("Notes").document(noteID).updateData([
                "timestamp": Timestamp(date: timestamp)
            ])
        } catch {
            print("Error adding timestamp to note: \(error)")
        }
    }

    // GET USERNAME BY ID
    func getUsernameByID(userID: String) async -> String {
        do {
            let doc = try await db.collection("Users").document(userID).getDocument()
            return doc.get("username") as? String ?? "Unknown User"
        } catch {
            print("Error reading username: \(error)")
            return "Unknown User"
        }
    }
}

