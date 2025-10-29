//
//  LoginView.swift
//  ChatterMap
//
//  Created by Noah Burnham on 10/29/25.
//
// have input for username
// and password
// and a button to login
// then it will query firebase for auth

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isSignedUp = false
    var body: some View {
        Text("CHATTERMAP")
        Text(isSignedUp ? "Log In" : "Sign Up")
        VStack(spacing: 20){
            TextField("Email", text: $username)
            TextField("Password", text: $password)
        }
        .padding(60)
    }
}

#Preview {
    LoginView()
}
