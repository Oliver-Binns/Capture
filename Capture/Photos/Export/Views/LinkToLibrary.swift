import Combine
import PhotosUI
import SwiftUI

struct LinkToLibrary: View {
    @State private var photoLibrary = PhotoLibrary()
    @State private var isLinking: Bool = false
    @State private var errorOccured: Bool = false

    let photo: Photo

    var body: some View {
        Button {
            Task {
                await displayPhotoSelector()
            }
        } label: {
            Label("Link to Photos Library", systemImage: "link")
            if let image = photoLibrary.image {
                image.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }.sheet(isPresented: $isLinking) {
            NavigationStack {
                PhotoSelector { asset in
                    isLinking = false
                    Task {
                        // todo: handle loading and errors
                        do {
                            try await photoLibrary.updateAsset(asset, with: photo)
                        } catch {
                            print("error occured: \(error)")
                        }
                    }
                }
                .navigationTitle("Select Photo")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isLinking = false
                        }
                    }
                }
                .macOSSheet()
                .environment(photoLibrary)
            }
        }.showPermissionDeniedError(
            $errorOccured,
            reason: "You must grant access to Photo Library in the Settings app."
        )
    }

    func displayPhotoSelector() async {
        do {
            try await photoLibrary.loadItems()
            isLinking = true
        } catch {
            errorOccured = true
        }
    }
}
