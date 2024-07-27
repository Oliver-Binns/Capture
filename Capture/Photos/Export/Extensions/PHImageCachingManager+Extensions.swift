import Photos
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension PHCachingImageManager {
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize = PHImageManagerMaximumSize,
        contentMode: PHImageContentMode = .default,
        options: PHImageRequestOptions?
    ) async
    -> PlatformImage? {
        await withCheckedContinuation { continuation in
            self.requestImage(for: asset,
                              targetSize: targetSize,
                              contentMode: contentMode,
                              options: options) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
}
