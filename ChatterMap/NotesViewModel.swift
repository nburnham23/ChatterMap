//
//  NotesViewModel.swift
//  ChatterMap
//
//  Created by jared on 10/29/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNote: Note? = nil
    private let firestoreService = FirestoreService()

    func loadNotes() async {
        self.notes = await firestoreService.getAllNotes()
    }
}
