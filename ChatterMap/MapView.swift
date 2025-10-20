//
//  MapView.swift
//  ChatterMap
//
//  Created by Noah Burnham on 10/20/25.
//

import SwiftUI

struct MapView: View {
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    
    var body: some View {
        HStack{
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Button("routes", action: {
                showMapView = false
                showRoutesView = true
                showNewNoteView = false
                showProfileView = false).frame(width: 100, height: 100) .foregroundColor(Color.white) .background(Color.blue) .clipShape(Circle()) Spacer()
                Button("write note", action: {
                    showMapView = false
                    showRoutesView = true
                    showNewNoteView = false
                    showProfileView = false}).frame(width: 100, height: 100) .foregroundColor(Color.white) .background(Color.blue) .clipShape(Circle()) Spacer()
                Button("profile", action: {
                    showMapView = false
                    showRoutesView = true
                    showNewNoteView = false
                    showProfileView = false}).frame(width: 100, height: 100) .foregroundColor(Color.white) .background(Color.blue) .clipShape(Circle()) Spacer() } } }
    
#Preview { RoutesView() }
}

