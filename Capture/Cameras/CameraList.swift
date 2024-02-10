import SwiftData
import SwiftUI

struct CamerasList: View {
    @Query private var cameras: [Camera]
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cameras) { camera in
                    Text("\(camera.make) \(camera.model)")
                }
            }
            .navigationTitle("Cameras")
            .toolbar {
                Button {
                    isEditing = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            
        }
        .tabItem {
            Label("Cameras", systemImage: "camera.fill")
        }.sheet(isPresented: $isEditing) {
            CameraEditor(camera: nil)
        }
    }
}
