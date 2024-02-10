import CoreLocation
import SwiftUI

struct PhotoEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let photo: Photo?
    
    @State private var timestamp: Date = Date()
    @State private var location: Location?
    @State private var camera: Camera?
    @State private var lens: Lens?
    @State private var filmSpeed: FilmSpeed = .fourHundred
    
    var body: some View {
        NavigationView {
            Form {
                Section("Preview") {
                    
                }
                
                Section("Metadata") {
                    DatePicker("Timestamp", selection: $timestamp)
                    
                    Button {
                        
                    } label: {
                        Label("Add Location", systemImage: "location")
                    }
                }
                
                Section("Equipment") {
                    if let camera {
                        
                    } else {
                        Button {
                            
                        } label: {
                            Label("Select Camera", systemImage: "camera")
                        }
                    }
                    
                    if let lens {
                        
                    } else {
                        Button {
                            
                        } label: {
                            Label("Select Lens", systemImage: "camera.aperture")
                        }
                    }
                }
                
                Section("Settings") {
                    Picker("Film Speed", selection: $filmSpeed) {
                        ForEach(FilmSpeed.allCases) { speed in
                            Text("\(speed.rawValue)").tag(speed)
                        }
                    }
                    
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
                        dismiss()
                    }
                }
            }
        }
    }
    
    
    
    func save() {
        if let photo {
            photo.timestamp = timestamp
            photo.location = location
            photo.camera = camera
            photo.lens = lens
            photo.filmSpeed = filmSpeed
        } else {
            modelContext.insert(
                Photo(timestamp: timestamp,
                      location: location,
                      camera: camera,
                      lens: lens,
                      filmSpeed: filmSpeed)
            )
        }
        
        try? modelContext.save()
    }
}
