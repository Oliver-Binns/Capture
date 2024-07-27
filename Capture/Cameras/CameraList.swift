import SwiftData
import SwiftUI

struct CamerasList: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var cameras: [Camera]
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(cameras) { camera in
                    NavigationLink("\(camera.make) \(camera.model)") {
                        CameraEditor(camera: camera)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            modelContext.delete(camera)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

                if cameras.count == 0 {
                    ContentUnavailableView("Add a camera to get started!",
                                           systemImage: "camera.fill")
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
            NavigationStack {
                CameraEditor(camera: nil)
            }
        }
    }
}
