//
//  ViewNoteView.swift
//  ChatterMap
//
//  Created by jared on 11/3/25.
//


import SwiftUI

struct ViewNoteView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool
    @Binding var showViewNoteView: Bool
    
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
                    
                    Text("Note contents")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    // INSERT ROUTES CODE HERE
                    
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
