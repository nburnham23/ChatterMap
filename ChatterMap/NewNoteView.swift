//
//  NewNoteView.swift
//  ChatterMap
//
//  Created by jared on 10/15/25.
//

import SwiftUI

struct NewNoteView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    
    @State private var noteText = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 8) {
                HStack {
                    Button("Close") {
                        showNewNoteView = false
                        showMapView = true
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Post") {
                        // ADD LOGIC FOR NEW NOTE CREATION
                        print("Posted note: \(noteText)")
                        noteText = ""
                        showNewNoteView = false
                        showMapView = true
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                TextField("Write a note...", text: $noteText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .autocapitalization(.sentences)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 5)
        }
        .ignoresSafeArea(.container)
        .animation(.easeInOut, value: showNewNoteView)
    }
}

#Preview {
    NewNoteView(
        showMapView: .constant(false),
        showRoutesView: .constant(false),
        showNewNoteView: .constant(true),
        showProfileView: .constant(false)
    )
}
