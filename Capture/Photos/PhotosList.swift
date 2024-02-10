import SwiftData
import SwiftUI

struct PhotosList: View {
    @Query var photos: [Photo]
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(photos) { photo in
                    Text(photo.timestamp.formatted(date: .abbreviated, time: .shortened))
                }
            }
            .navigationTitle("Photos")
            .toolbar {
                Button {
                    isEditing = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .tabItem {
            Label("Photos", systemImage: "photo.stack.fill")
        }
        .sheet(isPresented: $isEditing) {
            PhotoEditor(photo: nil)
        }
    }
}
