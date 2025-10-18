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
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: locationManager.lastKnownLocation?.latitude, longitude: locationManager.lastKnownLocation?.longitude), // Burlington, VT
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    
    var body : some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
        // TODO: find better way to make bottom button area
        Spacer()
        Spacer()
        Spacer()
        Spacer()
        HStack{
            Spacer()
            Button("routes", action: {})
                .frame(width: 100, height: 100)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Circle())
            Spacer()
            Button("write note", action: {})
                .frame(width: 100, height: 100)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Circle())
            Spacer()
            Button("profile", action: {})
                .frame(width: 100, height: 100)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Circle())
            Spacer()
        }
        Spacer()
    }
    
}

#Preview {
    ChatterMapView()
}
