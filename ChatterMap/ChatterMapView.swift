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
    @State private var showRoutesView = false
    @State private var showNewNoteView = false
    @State private var showProfileView = false
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121), // Burlington, VT
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    func toggleRoutesView() {
        showRoutesView = !showRoutesView
    }
    
    func toggleNewNoteView() {
        showNewNoteView = !showNewNoteView
    }
    
    func toggleProfileView() {
        showProfileView = !showProfileView
    }
    
    var body : some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
        // TODO: find better way to make bottom button area
        Spacer()
        Spacer()
        Spacer()
        Spacer()
        HStack{
            if !showRoutesView && !showNewNoteView && !showProfileView {
              Text("Back")
            }
            Spacer()
            Button("routes", action: {})
            Spacer()
            Button("write note", action: {})
            Spacer()
            Button("profile", action: {})
            Spacer()
        }
        Spacer()
    }
    
}

#Preview {
    ChatterMapView()
}
