//
//  ContentView.swift
//  ChatterMap
//
//  Created by jared on 10/8/25.
//

// a comment

import SwiftUI
import MapKit

struct ChatterMapView: View {
    @State private var showMapView = true
    @State private var showRoutesView = false
    @State private var showNewNoteView = false
    @State private var showProfileView = false
    @State private var showViewNoteView = false
    
    @StateObject private var notesVM = NotesViewModel()
    
    @Environment(LocationManager.self) var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    
    var body : some View {
        ZStack {
            Spacer()
            Map(position: $cameraPosition) {
                ForEach(notesVM.notes) { note in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: note.latitude, longitude: note.longitude)) {

                        Button {
                            //notesVM.selectedNote = note
                            showMapView = false
                            showRoutesView = false
                            showNewNoteView = false
                            showProfileView = false
                            showViewNoteView = true
                        } label: {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                
                UserAnnotation()
            }   .task {
                await notesVM.loadNotes()
            }
                .onAppear{
                    updateCameraPosition()
                }
                .mapControls{
                    MapUserLocationButton()
                }
            if showMapView {
                MapView(showMapView: $showMapView,
                        showRoutesView: $showRoutesView,
                        showNewNoteView: $showNewNoteView,
                        showProfileView: $showProfileView)
            } else if showRoutesView {
                RoutesView(showMapView: $showMapView,
                            showRoutesView: $showRoutesView,
                            showNewNoteView: $showNewNoteView,
                            showProfileView: $showProfileView)
            } else if showNewNoteView {
                NewNoteView(showMapView: $showMapView,
                            showRoutesView: $showRoutesView,
                            showNewNoteView: $showNewNoteView,
                            showProfileView: $showProfileView)
            } else if showProfileView {
                ProfileView(showProfileView: $showProfileView,
                            showMapView: $showMapView)
            }  else if showViewNoteView {
                ViewNoteView(showMapView: $showMapView,
                             showRoutesView: $showRoutesView,
                             showNewNoteView: $showNewNoteView,
                             showProfileView: $showProfileView,
                             showViewNoteView: $showViewNoteView)
            }
        }
    }
    func updateCameraPosition(){
        if let userLocation = locationManager.userLocation{
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation{
                cameraPosition = .region(userRegion)
            }
        }
    }
}

#Preview {
    ChatterMapView()
        .environment(LocationManager())
}
