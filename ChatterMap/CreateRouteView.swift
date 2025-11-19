//
//  CreateRouteView.swift
//  ChatterMap
//
//  Created by jared on 11/16/25.
//

import SwiftUI

struct CreateRouteView: View {
    @Binding var showRoutesView: Bool
    @Binding var showCreateRouteView: Bool
    
    @EnvironmentObject var user: User
    
    @State private var savedNotes: [Note] = []
    
    @State private var routeTitle: String = ""
    @State private var selectedNotes: Set<String> = []
    
    
    let firestoreService = FirestoreService()
    
    func toggleSelection(_ note: Note) {
        if selectedNotes.contains(note.id) {
            selectedNotes.remove(note.id)
        } else {
            selectedNotes.insert(note.id)
        }
    }

    var body: some View {
        ZStack {

            Color.black.opacity(0.001)
            
            VStack {
                
                VStack(spacing: 16) {
                    HStack {
                        Button("Close") {
                            showCreateRouteView = false
                            showRoutesView = true
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Route builder")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    TextField("Enter route title", text: $routeTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Text("Choose notes for route")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    Text("Select from your saved notes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    
                    // scroll through user's saved notes
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(savedNotes) { n in
                                NoteCell(note: n) {
                                    Button {
                                        toggleSelection(n)
                                    } label: {
                                        Image(systemName: selectedNotes.contains(n.id) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.blue)
                                            .font(.title3)
                                    }
                                }
                            }
                            if savedNotes.isEmpty {
                                Text("No saved posts yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                    .frame(maxHeight: 350)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    Button("Create route") {
                        Task {
                            await firestoreService.createRoute(route: Route(id: UUID().uuidString, routeName: routeTitle, includedNotes: Array(selectedNotes), userID: user.id))
                            selectedNotes.removeAll()
                            routeTitle = ""
                        }
                    }
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 60) //
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                savedNotes = await firestoreService.getSavedNotesByUser(parentUserID: user.id)
            }
        }
        .animation(.easeInOut, value: showRoutesView)
    }
}

#Preview {
    CreateRouteView(
        showRoutesView: .constant(false),
        showCreateRouteView: .constant(false)
    )
}
