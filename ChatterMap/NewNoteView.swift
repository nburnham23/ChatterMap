import SwiftUI

struct NewNoteView: View {
    @Binding var showMapView: Bool
    @Binding var showRoutesView: Bool
    @Binding var showNewNoteView: Bool
    @Binding var showProfileView: Bool

    @Environment(LocationManager.self) var locationManager
    @EnvironmentObject var user: User
    @State private var noteText = ""
    let firestoreService = FirestoreService()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 8) {
                HStack {
                    Button("Close") {
                        showNewNoteView = false
                        showMapView = true
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Post") {
                        let latitude = locationManager.userLocation?.coordinate.latitude ?? 0.0
                        let longitude = locationManager.userLocation?.coordinate.longitude ?? 0.0
                        
                        let note = Note(
                            id: UUID().uuidString,
                            userID: user.id,
                            noteText: noteText,
                            voteCount: 0,
                            latitude: latitude,
                            longitude: longitude,
                            timestamp: Date()
                        )
                        
                        Task{
                            await firestoreService.createNote(note: note)
                            noteText = ""
                        }
                        showNewNoteView = false
                        showMapView = true
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                TextField("Write a note...", text: $noteText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .autocapitalization(.sentences)
                    
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 5)
        }
        .ignoresSafeArea(.container)
        .animation(.easeInOut, value: showNewNoteView)
    }
}

#Preview {
    NewNoteView(
        showMapView: .constant(false),
        showRoutesView: .constant(false),
        showNewNoteView: .constant(true),
        showProfileView: .constant(false)
    ).environmentObject(User())
}
