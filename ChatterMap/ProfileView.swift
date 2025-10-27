//
//  ProfileView.swift
//  ChatterMap
//
//  Created by Owen Donohoe on 10/22/25.
//

import SwiftUI

struct ProfileView: View {
    // Placeholder data — easily replaced later with database values
    @State private var userName: String = "Example Name"
    @State private var userEmail: String = "example@email.com"
    @State private var totalNotes: Int = 12

    @State private var selectedButton: String? = nil

    @Binding var showProfileView: Bool
    @Binding var showMapView: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // MARK: - Close Button
                HStack {
                    Button("Close") {
                        showProfileView = false
                        showMapView = true
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // MARK: - User Info
                VStack(spacing: 8) {
                    Text(userName)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(userEmail)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Total Notes: \(totalNotes)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                // MARK: - Divider Line with Profile Circle
                GeometryReader { geometry in
                    ZStack {
                        // Left segment of the line
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: (geometry.size.width / 2) - 50, height: 3)
                            .offset(x: -((geometry.size.width / 4) + 25))

                        // Right segment of the line
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: (geometry.size.width / 2) - 50, height: 3)
                            .offset(x: ((geometry.size.width / 4) + 25))

                        // Profile Circle in the middle
                        Circle()
                            .stroke(Color.black, lineWidth: 3)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("👤")
                                    .font(.largeTitle)
                            )
                    }
                    .offset(x: 110)
                    .frame(height: 100)
                }
                .frame(height: 100)
                .padding(.vertical, 20)

                // MARK: - Blue Text Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        selectedButton = "Your Notes"
                    }) {
                        Text("Your Notes")
                            .font(.headline)
                            .frame(width: 140, height: 40)
                            .foregroundColor(selectedButton == "Your Notes" ? .blue.opacity(0.6) : .blue)
                    }

                    Button(action: {
                        selectedButton = "Saved Notes"
                    }) {
                        Text("Saved Notes")
                            .font(.headline)
                            .frame(width: 140, height: 40)
                            .foregroundColor(selectedButton == "Saved Notes" ? .blue.opacity(0.6) : .blue)
                    }
                }
                .padding(.top, -20)

                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ProfileView(showProfileView: .constant(true), showMapView: .constant(false))
}
