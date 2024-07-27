import SwiftData
import SwiftUI

struct CameraPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Binding var camera: Camera?
    @Query private var cameras: [Camera]

    var body: some View {
        List {
            ForEach(cameras) { camera in
                Button {
                    self.camera = camera
                    dismiss()
                } label: {
                    HStack {
                        Text("\(camera.make) \(camera.model)")
                        Spacer()

                        if camera == self.camera {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Camera")
    }
}
