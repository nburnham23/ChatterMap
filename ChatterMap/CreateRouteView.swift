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
    
    let firestoreService = FirestoreService()

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
                    
                    Text("Choose notes for route")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    // scroll through user's saved notes
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(savedNotes) { n in
                                NoteCell(note: n)
                            }
                            if savedNotes.isEmpty {
                                Text("No saved posts yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                    .padding(.horizontal)
                    
                    Spacer()
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
