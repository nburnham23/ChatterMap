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

/*
 TODO: BLOCK OUT PASSWORD
 clear error messages?
 */

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedUp = false
    @State private var errorMessage: String?
    
    let firestoreService = FirestoreService()
    
    var body: some View {
        Text("CHATTERMAP")
        Text(isSignedUp ? "Log In" : "Sign Up")
        VStack(spacing: 20){
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
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
            Button(action: createUser){
                Text("Sign up")
            }

            if isSignedUp {
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
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isSignedUp = true
                print("User logged in: \(result?.user.uid ?? "Unknown UID")")
            }
        }
        // TODO: create a user object which will be environment object
    }
    func createUser(){
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isSignedUp = true
                print("User signed up: \(result?.user.uid ?? "Unknown UID")")
            }
        }
        // TODO: create a user object which will be environment object
        // TODO: users have usernames
        let user = User(
            id: UUID().uuidString,
            username: email,
            notes: []
        )
        Task{
            await firestoreService.createUser(user: user)
        }
    }
}

#Preview {
    LoginView()
}
