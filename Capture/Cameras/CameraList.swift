import SwiftData
import SwiftUI

struct CamerasList: View {
    @Query private var cameras: [Camera]
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cameras) { camera in
                    NavigationLink("\(camera.make) \(camera.model)") {
                        CameraEditor(camera: camera)
                    }
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
            NavigationView {
                CameraEditor(camera: nil)
            }
        }
    }
}
