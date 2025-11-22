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
import FirebaseAuth

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @Binding var isAuthenticated: Bool
    
    @EnvironmentObject var user: User
    
    let firestoreService = FirestoreService()
    
    var body: some View {
        
        VStack(spacing: 20){
            Text("CHATTERMAP")
                .font(.title)
            Text(isAuthenticated ? "Log In" : "Sign Up")
                .font(.title2)

            TextField("Username", text: $username)
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

            if isAuthenticated {
                Text("✅ Successfully logged in!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding(60)
        
    } // body
    
    func loginUser() {
        // Check if either text field is empty
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        let usernameFormatted = "\(username)@chattermap.com"

        Auth.auth().signIn(withEmail: usernameFormatted, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let authUser = result?.user{
                Task {
                    await loadUserData(uid: authUser.uid)
                    user.updateUser(id: authUser.uid, username: username)
                    isAuthenticated = true
                }
                print(user.username)
            }
        }
    }

    func createUser() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        let usernameFormatted = "\(username)@chattermap.com"
        
        Auth.auth().createUser(withEmail: usernameFormatted, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let authUser = result?.user {
                // Create new user in Firestore
                let newUser = User(
                    id: authUser.uid,
                    username: username,
                    postedNotes: [],
                    savedNotes: []
                )
                Task {
                    await firestoreService.createUser(user: newUser)
                    // Update environment object
                    user.updateUser(id: authUser.uid, username: username)
                    isAuthenticated = true
                }
            }
        }
    }
    func loadUserData(uid: String) async {
        // Fetch user from Firestore
        if let fetchedUser = await firestoreService.getUserById(uid: uid) {
            user.updateUser(id: fetchedUser.id, username: fetchedUser.username)
            user.postedNotes = fetchedUser.postedNotes
            user.savedNotes = fetchedUser.savedNotes
        }
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false)).environmentObject(User())
}
