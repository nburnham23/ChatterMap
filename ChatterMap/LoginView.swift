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
    @State private var errorMessage: String?
    
    var body: some View {
        Text("CHATTERMAP")
        Text(isSignedUp ? "Log In" : "Sign Up")
        VStack(spacing: 20){
            TextField("Email", text: $username)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            TextField("Password", text: $password)
                .autocapitalization(.none)


            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: loginUser) {
                Text("Log In")
            }

            if isLoggedIn {
                Text("✅ Successfully logged in!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding(60)
        
    } // body

    func loginUser() {
        // Check if either text field is empty
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
                print("User logged in: \(result?.user.uid ?? "Unknown UID")")
            }
        }

        
    }
    


    
}

#Preview {
    LoginView()
}
