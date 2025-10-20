//
//  MapView.swift
//  ChatterMap
//
//  Created by Noah Burnham on 10/20/25.
//

import SwiftUI

import SwiftUI

struct MapView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button("routes") {
                    showMapView = false
                    showRoutesView = true
                    showNewNoteView = false
                    showProfileView = false
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Circle())

                Spacer()
                Button("write note") {
                    showMapView = false
                    showRoutesView = false
                    showNewNoteView = true
                    showProfileView = false
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Circle())

                Spacer()
                Button("profile") {
                    showMapView = false
                    showRoutesView = false
                    showNewNoteView = false
                    showProfileView = true
                }
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Circle())

                Spacer()
            }
        }
    }
}
    
#Preview {
    MapView(
        showMapView: .constant(true),
        showRoutesView: .constant(false),
        showNewNoteView: .constant(false),
        showProfileView: .constant(false)
    )
}


