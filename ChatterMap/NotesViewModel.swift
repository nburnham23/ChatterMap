//
//  NotesViewModel.swift
//  ChatterMap
//
//  Created by jared on 10/29/25.
//

import SwiftUI
import FirebaseFirestore

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNote: Note? = nil
    private let firestoreService = FirestoreService()

    
    private var notesListener: ListenerRegistration?
    
    func startListening() {
        stopListening()
        
        // TODO: wtf does this mean
        notesListener = firestoreService.listenToAllNotes { [weak self] notes in
            self?.notes = notes
            print("Notes updated: \(notes.count) notes")
        }
    }
    
    func stopListening() {
        notesListener?.remove()
        notesListener = nil
    }
    
    func loadNotes() async {
        self.notes = await firestoreService.getAllNotes()
    }
    
    // Clean up listener when view model is deallocated
    // TODO: deinit????
    deinit {
        stopListening()
    }
}
