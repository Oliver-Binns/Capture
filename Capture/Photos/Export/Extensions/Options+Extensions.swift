import Photos

extension PHContentEditingInputRequestOptions {
    static var networkAllowed: PHContentEditingInputRequestOptions {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true
        return options
    }
}
