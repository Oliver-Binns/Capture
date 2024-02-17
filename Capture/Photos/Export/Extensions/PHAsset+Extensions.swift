import Photos

extension PHAsset {
    func contentEditingInput(
        with options: PHContentEditingInputRequestOptions = .networkAllowed
    ) async -> (PHContentEditingInput?, [AnyHashable: Any]) {
        await withCheckedContinuation { continuation in
            requestContentEditingInput(with: options) { input, info in
                continuation.resume(returning: (input, info))
            }
        }
    }
}
