//
//  ContentView.swift
//  ChatterMap
//
//  Created by jared on 10/8/25.
//

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
    // don't let the user move the map
    let interactionModes: MapInteractionModes = []
    var body: some View {
        ZStack {
            Spacer()
            
            // Main map
            Map(position: $cameraPosition,
                interactionModes: interactionModes) {
                // Show note pins
                ForEach(notesVM.notes) { note in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: note.latitude, longitude: note.longitude)) {
                        Button {
                            notesVM.selectedNote = note
                            showMapView = false
                            showRoutesView = false
                            showNewNoteView = false
                            showProfileView = false
                            showViewNoteView = true
                        } label: {
                            MapPinShape()
                                .fill(Color.red)
                                .overlay(
                                    MapPinShape().stroke(Color.white, lineWidth: 2)
                                )
                                .frame(width: 20, height: 35)
                                .shadow(radius: 2)
                        }
                    }
                }
                
                // User location
                UserAnnotation()
            }
            .task {
                await notesVM.loadNotes()
            }
            .onAppear {
                updateCameraPosition()
            }
            
            // View switching logic
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
            } else if showViewNoteView, let selectedNote = notesVM.selectedNote {
                ViewNoteView(note: selectedNote,
                             showMapView: $showMapView,
                             showRoutesView: $showRoutesView,
                             showNewNoteView: $showNewNoteView,
                             showProfileView: $showProfileView,
                             showViewNoteView: $showViewNoteView)
            }
        }
    }
    
    func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

// MARK: - Custom Pin Shape
struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let curveHeight = rect.height * 0.3
        let topY = rect.minY + curveHeight
        
        // Start left of the curved top
        path.move(to: CGPoint(x: rect.minX, y: topY))
        
        // Curved top
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: topY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        
        // Pointed bottom
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: topY))
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    ChatterMapView()
        .environment(LocationManager())
}
