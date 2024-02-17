import Photos
import UIKit

extension PHCachingImageManager {
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize = PHImageManagerMaximumSize,
        contentMode: PHImageContentMode = .default,
        options: PHImageRequestOptions?
    ) async
    -> UIImage?  {
        await withCheckedContinuation { continuation in
            self.requestImage(for: asset,
                              targetSize: targetSize,
                              contentMode: contentMode,
                              options: options) { image, userInfo in
                continuation.resume(returning: image)
            }
        }
    }
}

