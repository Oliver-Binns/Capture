import CoreLocation
import SwiftUI

@MainActor
struct PhotoEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let roll: FilmRoll
    let photo: Photo?

    init(roll: FilmRoll, photo: Photo?) {
        self.roll = roll
        self.photo = photo
    }

    private var captureViewModel = CaptureViewModel()
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
                CaptureView(viewModel: captureViewModel)
                    .aspectRatio(3/2, contentMode: .fit)
                    .padding(.vertical, -12)
                    .padding(.horizontal, -16)
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
            if let preview = photo?.preview {
                captureViewModel.loadFromStorage(data: preview)
            }
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
            photo.preview = captureViewModel.data
            photo.timestamp = timestamp
            photo.location = location
            photo.camera = camera
            photo.lens = lens
            photo.filmSpeed = filmSpeed
        } else {
            modelContext.insert(
                Photo(preview: captureViewModel.data,
                      timestamp: timestamp,
                      location: location,
                      camera: camera,
                      lens: lens,
                      filmSpeed: filmSpeed,
                      roll: roll)
            )
        }

        try? modelContext.save()
    }
}
