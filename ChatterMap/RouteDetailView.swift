//
//  RouteDetailView.swift
//  ChatterMap
//
//  Created by jared on 11/16/25.
//

import SwiftUI

struct RouteDetailView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    @Binding var showRouteDetailView: Bool
    
    @EnvironmentObject var user: User
    
    @State private var nearbyRoutes: [Route] = []

    let firestoreService = FirestoreService()

    var body: some View {
        ZStack {

            Color.black.opacity(0.001)
            
            VStack {
                
                VStack(spacing: 16) {
                    HStack {
                        Button("Close") {
                            showRoutesView = false
                            showMapView = true
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Route details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    // make this scroll through notes in the route
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(nearbyRoutes) { r in
                                RouteCell(route: r)
                            }
                            if nearbyRoutes.isEmpty {
                                Text("No routes yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 60) //
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                nearbyRoutes = await firestoreService.getAllRoutes()
            }
        }
        .animation(.easeInOut, value: showRoutesView)
    }
}

#Preview {
    RouteDetailView(
        showMapView: .constant(false),
        showRoutesView: .constant(false),
        showNewNoteView: .constant(false),
        showProfileView: .constant(false),
        showRouteDetailView: .constant(true)
    )
}
