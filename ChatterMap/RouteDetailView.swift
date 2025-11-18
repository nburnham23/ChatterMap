//
//  RouteDetailView.swift
//  ChatterMap
//
//  Created by jared on 11/16/25.
//

import SwiftUI

struct RouteDetailView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    @Binding var showRouteDetailView: Bool
    @Binding var selectedRoute: Route
    
    @State var includedNotes: [Note] = []
    
    @EnvironmentObject var user: User
    
    let firestoreService = FirestoreService()

    var body: some View {
        ZStack {

            Color.black.opacity(0.001)
            
            VStack {
                
                VStack(spacing: 16) {
                    HStack {
                        Button("Close") {
                            showRouteDetailView = false
                            showRoutesView = true
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Route details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    // make this scroll through notes in the route
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(includedNotes) { n in
                                NoteCell(note: n)
                            }
                            if includedNotes.isEmpty {
                                Text("No notes in this route.")
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
                var tempIncludedNotes: [Note] = []
                for noteID in selectedRoute.includedNotes {
                    if let note = await firestoreService.getNote(id: noteID) {
                        tempIncludedNotes.append(note)
                    }
                }
                includedNotes = tempIncludedNotes
            }
        }
        .animation(.easeInOut, value: showRoutesView)
    }
}

#Preview {
    RouteDetailView(
        showMapView: .constant(false),
        showRoutesView: .constant(false),
        showNewNoteView: .constant(false),
        showProfileView: .constant(false),
        showRouteDetailView: .constant(false),
        selectedRoute: .constant(Route.preview)
    ).environmentObject(User())
}

/*
 
 
 import SwiftUI

 struct RouteDetailView: View {
     @Binding var showMapView: Bool
     @Binding var showRoutesView: Bool
     @Binding var showNewNoteView: Bool
     @Binding var showProfileView: Bool
     @Binding var showRouteDetailView: Bool
     @Binding var selectedRoute: Route
     
     @State var includedNotes: [Note] = []
     
     @EnvironmentObject var user: User
     
     let firestoreService = FirestoreService()
     
     var body: some View {
         ZStack {
             
             Color.black.opacity(0.001)
             
             VStack {
                 
                 VStack(spacing: 16) {
                     HStack {
                         Button("Close") {
                             showRouteDetailView = false
                             showRoutesView = true
                         }
                         .foregroundColor(.red)
                         
                         Spacer()
                     }
                     .padding(.horizontal)
                     .padding(.top)
                     
                     Text("Route details")
                         .font(.title2)
                         .fontWeight(.semibold)
                         .padding(.bottom, 10)
                     
                     // make this scroll through notes in the route
                     ScrollView {
                         LazyVStack(spacing: 12) {
                             if includedNotes.isEmpty {
                                 Text("No notes in this route.")
                                     .foregroundColor(.gray)
                                     .padding()
                             } else {
                                 ForEach(includedNotes) { n in
                                     NoteCell(note: n) {
                                     }
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
                     var tempIncludedNotes: [Note] = []
                     for noteID in selectedRoute.includedNotes {
                         if let note = await firestoreService.getNote(id: noteID) {
                             tempIncludedNotes.append(note)
                         }
                     }
                     includedNotes = tempIncludedNotes
                 }
             }
             .animation(.easeInOut, value: showRoutesView)
         }
     }
 }

 #Preview {
     RouteDetailView(
         showMapView: .constant(false),
         showRoutesView: .constant(false),
         showNewNoteView: .constant(false),
         showProfileView: .constant(false),
         showRouteDetailView: .constant(false),
         selectedRoute: .constant(Route.preview)
     ).environmentObject(User())
 }


 
 */
