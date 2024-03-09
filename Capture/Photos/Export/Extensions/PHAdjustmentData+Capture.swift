import Photos

extension PHAdjustmentData {
    convenience init(version: String = "1.0.0",
                     data: Data) {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            fatalError("Error: unable to get bundle identifier")
        }
        
        self.init(formatIdentifier: bundleID,
                  formatVersion: version,
                  data: data)
    }
}
