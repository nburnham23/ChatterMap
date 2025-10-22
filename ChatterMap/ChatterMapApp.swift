//
//  ChatterMapApp.swift
//  ChatterMap
//
//  Created by jared on 10/8/25.
//

import SwiftUI

@main
struct ChatterMapApp: App {
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized{
                ChatterMapView()
            }else{
                LocationDeniedView()
            }
        }
        .environment(locationManager)
    }
}
