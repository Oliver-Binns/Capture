import CoreImage
import Observation
import Photos

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum PhotoLibraryError: Error {
    case accessDenied
    case unknown
}

@Observable
final class PhotoLibrary {
    private(set) var authorizationStatus: PHAuthorizationStatus = .notDetermined

    private let imageCachingManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.allowsCachingHighQualityImages = true
        return manager
    }()

    private(set) var results = FetchResultCollection()

    var image: PlatformImage?

    func loadItems() async throws {
        switch authorizationStatus {
        case .notDetermined:
            // request authorization and then recurse!
            authorizationStatus = await PHPhotoLibrary
                .requestAuthorization(for: .readWrite)
            return try await loadItems()
        case .limited, .authorized:
            // we are allowed photo access, allow the user to choose
            return
        case .denied, .restricted:
            // no access to photos, display an alert!
            throw PhotoLibraryError.accessDenied
        @unknown default:
            throw PhotoLibraryError.unknown
        }
    }

    func fetchImage(localIdentifier: String) async -> PlatformImage? {
        let results = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier],
                                          options: nil)
        guard let asset = results.firstObject else { return nil }

        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true

        return await imageCachingManager.requestImage(for: asset, options: options)
    }

    func updateAsset(_ asset: PHAsset, with photo: Photo) async throws {
        let (input, _) = await asset.contentEditingInput()

        guard let input,
              let url = input.fullSizeImageURL else {
            fatalError("Error: cannot get editing input")
        }

        let metadata = photo.metadata
        let adjustmentData = PHAdjustmentData(data: try JSONSerialization.data(withJSONObject: metadata))

        let editingOutput = PHContentEditingOutput(contentEditingInput: input)
        editingOutput.adjustmentData = adjustmentData

        let imageData = try Data(contentsOf: url)
        let imageRef: CGImageSource = CGImageSourceCreateWithData((imageData as CFData), nil)!
        let uti: CFString = CGImageSourceGetType(imageRef)!
        let dataWithEXIF: NSMutableData = NSMutableData(data: imageData)
        let destination: CGImageDestination = CGImageDestinationCreateWithData((dataWithEXIF as CFMutableData),
                                                                               uti, 1,
                                                                               nil)!
        CGImageDestinationAddImageFromSource(destination, imageRef, 0, (metadata as CFDictionary))
        CGImageDestinationFinalize(destination)

        try dataWithEXIF.write(to: editingOutput.renderedContentURL)

        try await PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest(for: asset)
            if let location = photo.location {
                request.location = CLLocation(latitude: location.latitude,
                                              longitude: location.longitude)
            }
            request.revertAssetContentToOriginal()
            request.creationDate = photo.timestamp
            request.contentEditingOutput = editingOutput
        }
    }
}
