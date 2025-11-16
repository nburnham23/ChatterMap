//
//  RoutesView.swift
//  ChatterMap
//
//  Created by jared on 10/15/25.
//

import SwiftUI

struct RoutesView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    @State private var showRouteDetailView = false
    @State private var showCreateRouteView = false
    
    @EnvironmentObject var user: User
    
    @State private var nearbyRoutes: [Route] = []
    @State private var selectedRoute: Route = Route.preview

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
                        
                        Button("+") {
                            showCreateRouteView = true
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Nearby Routes")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(nearbyRoutes) { r in
                                Button {
                                    selectedRoute = r
                                    showRouteDetailView = true
                                } label: {
                                    RouteCell(route: r)
                                }
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
            
            if showRouteDetailView {
                RouteDetailView(showMapView: $showMapView,
                                showRoutesView: $showRoutesView,
                                showNewNoteView: $showNewNoteView,
                                showProfileView: $showProfileView,
                                showRouteDetailView: $showRouteDetailView,
                                selectedRoute: $selectedRoute)
            }
            if showCreateRouteView {
                CreateRouteView(showRoutesView: $showRoutesView,
                                showCreateRouteView: $showCreateRouteView)
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
    RoutesView(
        showMapView: .constant(false),
        showRoutesView: .constant(true),
        showNewNoteView: .constant(false),
        showProfileView: .constant(false)
    )
}
