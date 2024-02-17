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
                Image(uiImage: image)
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
                        } catch let error as PHPhotosError {
                            switch error.code {
                            case .accessRestricted:
                                print("restricted")
                            case .accessUserDenied:
                                print("denied")
                            case .changeNotSupported:
                                print("not supported")
                            case .identifierNotFound:
                                print("id not found")
                            case .internalError:
                                print("internal")
                            case .invalidResource:
                                print("invalid")
                            case .libraryInFileProviderSyncRoot:
                                print("sync root")
                            case .libraryVolumeOffline:
                                print("volume offline")
                            case .missingResource:
                                print("missing")
                            case .multipleIdentifiersFound:
                                print("multiple")
                            case .networkAccessRequired:
                                print("network req")
                            case .networkError:
                                print("network err")
                            case .notEnoughSpace:
                                print("space")
                            case .operationInterrupted:
                                print("interupted")
                            case .persistentChangeDetailsUnavailable:
                                print("unavailable")
                            case .persistentChangeTokenExpired:
                                print("expired")
                            case .relinquishingLibraryBundleToWriter:
                                print("relinquish")
                            case .switchingSystemPhotoLibrary:
                                print("switching")
                            case .userCancelled:
                                print("cancelled")
                            case .requestNotSupportedForAsset:
                                print("not supported")
                            @unknown default:
                                print("unknown")
                            }
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
