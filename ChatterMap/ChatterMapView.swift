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
    
    let manager = CLLocationManager()
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121), // Burlington, VT
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    var body : some View {
        //Map(coordinateRegion: $region)
        Map(position: $cameraPosition){
            UserAnnotation()
        }
        .mapControls{
            MapUserLocationButton()
        }
        .onAppear {
            manager.requestWhenInUseAuthorization()
        }
            .ignoresSafeArea()
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
            ProfileView(showMapView: $showMapView,
                        showRoutesView: $showRoutesView,
                        showNewNoteView: $showNewNoteView,
                        showProfileView: $showProfileView)
        }
    }
    
}

#Preview {
    ChatterMapView()
}
