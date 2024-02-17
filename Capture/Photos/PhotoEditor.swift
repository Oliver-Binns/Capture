import CoreLocation
import SwiftUI

struct PhotoEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let photo: Photo?
    
    init(photo: Photo?) {
        self.photo = photo
    }
    
    @State private var timestamp: Date = Date()
    @State private var location: Location?
    @State private var camera: Camera?
    @State private var lens: Lens?
    @State private var filmSpeed: FilmSpeed = .fourHundred
    
    @State private var hasAppeared: Bool = false
    
    private var cameraText: String {
        if let camera {
            "\(camera.make) \(camera.model)"
        } else {
            "Select Camera"
        }
    }
    
    private var lensText: String {
        if let lens {
            "\(lens.make) \(lens.model)"
        } else {
            "Select Lens"
        }
    }
    
    var body: some View {
        Form {
            Section("Preview") {
                
            }
            
            Section("Metadata") {
                DatePicker("Timestamp", selection: $timestamp)
                LocationButton(location: $location)
            }
            
            Section("Equipment") {
                NavigationLink {
                    CameraPicker(camera: $camera)
                } label: {
                    Label(cameraText, systemImage: "camera")
                }
                
                NavigationLink {
                    LensPicker(lens: $lens)
                } label: {
                    Label(lensText, systemImage: "camera.aperture")
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
            
            if let photo {
                Section("Export Data") {
                    LinkToLibrary(photo: photo)
                }
            }
        }
        .navigationTitle("Log Photo")
        .macOSSheet()
        .onAppear {
            guard !hasAppeared else { return }
            timestamp = photo?.timestamp ?? Date()
            location = photo?.location
            camera = photo?.camera
            lens = photo?.lens
            filmSpeed = photo?.filmSpeed ?? filmSpeed
            hasAppeared = true
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Save") {
                    save()
                    dismiss()
                }
            }
            
            if photo == nil {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func save() {
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
