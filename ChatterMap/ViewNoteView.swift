//
//  ViewNoteView.swift
//  ChatterMap
//
//  Created by jared on 11/3/25.
//

import SwiftUI

struct ViewNoteView: View {
    let note: Note
    
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    @Binding var showViewNoteView: Bool
    
    @Environment(LocationManager.self) var locationManager
    @State private var commentText = ""
    
    @State private var comments: [Comment] = []
    @State private var localSavedNotes: [String] = []
    
    @EnvironmentObject var user: User
    
    let firestoreService = FirestoreService()
    
    // Local state for voting
    @State private var voteCount: Int
    @State private var hasVoted = false
    
    init(note: Note, showMapView: Binding<Bool>, showRoutesView: Binding<Bool>, showNewNoteView: Binding<Bool>, showProfileView: Binding<Bool>, showViewNoteView: Binding<Bool>) {
        self.note = note
        self._showMapView = showMapView
        self._showRoutesView = showRoutesView
        self._showNewNoteView = showNewNoteView
        self._showProfileView = showProfileView
        self._showViewNoteView = showViewNoteView
        self._voteCount = State(initialValue: note.voteCount)
    }
    
    func toggleSavedState(_ note: Note) {
        Task {
            if localSavedNotes.contains(note.id) {
                try? await firestoreService.unsaveNoteToUser(userID: user.id, noteID: note.id)
                localSavedNotes.removeAll { $0 == note.id }
                user.savedNotes.removeAll { $0 == note.id }
                print("Note unsaved successfully.")
            } else {
                // SAVE
                try? await firestoreService.saveNoteToUser(userID: user.id, noteID: note.id)
                localSavedNotes.append(note.id)
                user.savedNotes.append(note.id)
                print("Note saved successfully.")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.001)
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    HStack {
                        Button("Close") {
                            showRoutesView = false
                            showMapView = true
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button {
                            toggleSavedState(note)
                        } label: {
                            Image(systemName: localSavedNotes.contains(note.id) ? "bookmark" : "bookmark.slash")
                                .foregroundColor(.red)
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Note written by \(note.userID)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    
                    if let timestamp = note.timestamp {
                        Text("Posted: \(timestamp.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                    } else {
                        Text("Posted: Time unknown")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                    }
                    
                    Text(note.noteText)
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    // Vote buttons + vote count
                    HStack {
                        Button(action: {
                            if !hasVoted {
                                voteCount += 1
                                hasVoted = true
                                var updatedNote = note
                                updatedNote.voteCount = voteCount
                                Task {
                                    await firestoreService.updateVoteCount(note: updatedNote)
                                }
                            }
                        }) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                        
                        Spacer()
                        
                        Text("\(voteCount)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(voteCount > 0 ? .green : (voteCount < 0 ? .red : .black))
                        
                        Spacer()
                        
                        Button(action: {
                            if !hasVoted {
                                voteCount -= 1
                                hasVoted = true
                                var updatedNote = note
                                updatedNote.voteCount = voteCount
                                Task {
                                    await firestoreService.updateVoteCount(note: updatedNote)
                                }
                            }
                        }) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(comments) { c in
                                CommentCell(comment: c)
                            }
                            if comments.isEmpty {
                                Text("No comments yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                    .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Button("Close") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button("Post") {
                                
                                let comment = Comment(
                                    id: UUID().uuidString,
                                    parentNoteID: note.id,
                                    userID: UUID().uuidString,
                                    commentText: commentText,
                                    voteCount: 0
                                )
                                
                                Task{
                                    await firestoreService.createComment(comment: comment)
                                }
                                showNewNoteView = false
                                showMapView = true
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        TextField("Write a note...", text: $commentText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .autocapitalization(.sentences)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 60)
            }
        }
        .ignoresSafeArea(.container)
        .onAppear {
            localSavedNotes = user.savedNotes
            Task {
                comments = await firestoreService.getCommentsByNote(parentNoteID: note.id)
            }
        }
        .animation(.easeInOut, value: showRoutesView)
    }
}

#Preview {
    RoutesView(
        showMapView: .constant(false),
        showRoutesView: .constant(true),
        showNewNoteView: .constant(false),
        showProfileView: .constant(false)
    )
}
