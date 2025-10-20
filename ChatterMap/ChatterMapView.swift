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
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121), // Burlington, VT
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    var body : some View {
        ZStack {
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
            if showMapView {
                MapView(showMapView: $showMapView,
                        showRoutesView: $showRoutesView,
                        showNewNoteView: $showNewNoteView,
                        showProfileView: $showProfileView)
            } else if showRoutesView {
                RoutesView()
            } else if showNewNoteView {
                NewNoteView()
            } else if showProfileView {
                ProfileView()
            }
        }
    }
    
}

#Preview {
    ChatterMapView()
}
