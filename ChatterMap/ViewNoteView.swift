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
    
    @EnvironmentObject var user: User
    
    let firestoreService = FirestoreService()
    
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
                        
                        if !user.savedNotes.contains(note.id) {
                            Button("Save") {
                                Task {
                                    try? await firestoreService.saveNoteToUser(userID: user.id, noteID: note.id)
                                    if !user.savedNotes.contains(note.id) {
                                        user.savedNotes.append(note.id)
                                    }
                                    print("Note saved successfully.")
                                }
                            }
                            .foregroundColor(.red)
                        } else {
                            Button("Unsave") {
                                Task {
                                    try? await firestoreService.unsaveNoteToUser(userID: user.id, noteID: note.id)
                                    if user.savedNotes.contains(note.id) {
                                        user.savedNotes.removeAll{ $0 == note.id}
                                    }
                                    print("Note unsaved successfully.")
                                }
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Note written by \(note.userID)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    Text(note.noteText)
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    Text("Upvote count: \(note.voteCount)")
                        .font(.title2)
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
                    .frame(maxHeight: 250) // you can adjust this
                    .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Button("Close") {
                                // this line closes the keyboard
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button("Post") {
                                //Records coordinates of user when posting note
                                let latitude = locationManager.userLocation?.coordinate.latitude ?? 0.0
                                let longitude = locationManager.userLocation?.coordinate.longitude ?? 0.0
                                // For now, just print the note text
                                // TODO: upload to firebase
                                print("Posted note: \(commentText)")
                                print("(\(latitude), \(longitude)")
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
