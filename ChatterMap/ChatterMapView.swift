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
    test
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
                Spacer()
                Button("routes", action: {toggleRoutesView()})
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
                Spacer()
                Button("write note", action: {toggleNewNoteView()})
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
                Spacer()
                Button("profile", action: {toggleProfileView()})
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
                Spacer()
            }
        }
        Spacer()
    }
    
}

#Preview {
    ChatterMapView()
}
