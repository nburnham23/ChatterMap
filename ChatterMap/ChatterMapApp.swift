//
//  ChatterMapApp.swift
//  ChatterMap
//
//  Created by jared on 10/8/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct ChatterMapApp: App {
    @State private var locationManager = LocationManager()
    @StateObject private var user = User()
    @State private var isAuthenticated = false
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if !isAuthenticated {
                LoginView(isAuthenticated: $isAuthenticated)
                    .environmentObject(user)
            } else if locationManager.isAuthorized {
                ChatterMapView()
                    .environment(locationManager)
                    .environmentObject(user)
            } else {
                LocationDeniedView()
                    .environment(locationManager)
                    .environmentObject(user)
            }
        }
    }
}
