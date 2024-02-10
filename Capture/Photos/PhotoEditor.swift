import SwiftUI

struct PhotoEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let photo: Photo?
    
    @State var timestamp: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Preview") {
                    
                }
                
                Section("Metadata") {
                    DatePicker("Timestamp", selection: $timestamp)
                    Text("Location")
                }
                
                Section("Equipment") {
                    Text("Select Camera")
                    Text("Select Lens")
                }
                
                Section("Settings") {
                    Text("Film Speed (Camera)")
                    Text("Aperture (Lens)")
                }
            }
            .navigationTitle("Log Photo")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        save()
                    }
                }
            }
        }
    }
    
    func save() {
        
    }
}
