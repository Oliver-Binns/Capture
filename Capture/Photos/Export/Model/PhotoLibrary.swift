import Observation
import Photos
import UIKit

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
    
    func fetchImage(localIdentifier: String) async -> UIImage? {
        let results = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier],
                                          options: nil)
        guard let asset = results.firstObject else { return nil }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        
        let (image, _) = await imageCachingManager.requestImage(for: asset, options: options)
        return image
    }
    
    /*let tiffProperties = [
        kCGImagePropertyTIFFMake: data.camera?.make,
        kCGImagePropertyTIFFModel: data.camera?.model,
        kCGImagePropertyExifLensMake: data.lens?.make,
        kCGImagePropertyExifLensModel: data.lens?.model,
    ] as CFDictionary
        
    let properties = [
        kCGImagePropertyExifDictionary as String: tiffProperties
    ] as CFDictionary*/
    
    func updateAsset(_ asset: PHAsset, 
                     with data: Photo) {
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest(for: asset)
            if let location = data.location {
                request.location = CLLocation(latitude: location.latitude,
                                              longitude: location.longitude)
            }
            request.creationDate = data.timestamp
        }
    }
}


