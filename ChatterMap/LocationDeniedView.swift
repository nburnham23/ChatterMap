//
//  LocationDeniedView.swift
//  ChatterMap
//
//  Created by Noah Burnham on 10/22/25.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView(
            label: {
                Label("Need location services to use ChatterMap", systemImage: "location.square")
            },
            description:{
                
                Text("""
1. Tap the button below and go to "Privacy and Security"
2. Tap on "Location Services"
3. Locate the "ChatterMap" app and tap on it
4. Change the setting to "While using the app"
""")
                .multilineTextAlignment(.leading)
            },
            actions: {
                Button(action: {
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!
                    )
                }){
                    Text("Open Settings")
                }
                .buttonStyle(.borderedProminent)
            }
        )
    }
}

#Preview {
    LocationDeniedView()
}
