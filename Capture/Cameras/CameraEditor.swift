import SwiftUI

struct CameraEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let camera: Camera?
    
    @State private var make: String = ""
    @State private var model: String = ""
    
    private var isInvalid: Bool {
        make.isEmpty && model.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Make", text: $make)
                TextField("Model", text: $model)
            }.onAppear {
                make = camera?.make ?? ""
                model = camera?.model ?? ""
            }.toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }.disabled(isInvalid)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        
                    }
                }
            }
        }
    }
    
    func save() {
        if let camera {
            camera.make = make
            camera.model = model
        } else {
            modelContext.insert(
                Camera(make: make,
                       model: model)
            )
        }
        try? modelContext.save()
    }
}
