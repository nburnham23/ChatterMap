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
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized{
                ChatterMapView()
            }else{
                LocationDeniedView()
            }
        }
        .environment(locationManager)
        .environmentObject(User())
    }
}
