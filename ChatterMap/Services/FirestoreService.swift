//
//  FirestoreService.swift
//  ChatterMap
//  ALL Database Getters/Setters
//  Created by user285571 on 10/22/25.
//
import FirebaseCore
import FirebaseFirestore

class FirestoreService {
    let db = Firestore.firestore()
    // Create User
    func createUser(user: User) async {
        do {
            try await db.collection("Users").document(user.id).setData([
                "id": user.id,
                "username": user.username,
                "postedNotes": user.postedNotes,
                "savedNotes": user.savedNotes
            ])
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func saveNoteToUser(userID: String, noteID: String) async throws{
        let userRef = db.collection("Users").document(userID)
            try await userRef.updateData([
                "savedNotes": FieldValue.arrayUnion([noteID])
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
    
    // Create Note
    func createNote(note: Note) async {
        do {
            try await db.collection("Notes").document(note.id).setData([
                "id": note.id,
                "userID": note.userID,
                "noteText": note.noteText,
                "voteCount": note.voteCount,
                "latitude": note.latitude,
                "longitude": note.longitude
            ])
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
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
            let snapshot = try await db.collection("Notes").getDocuments()
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
            print("Document successfully written!")
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
}

