import AVFoundation

protocol CameraPermissionManager {
    static func authorizationStatus(for mediaType: AVMediaType)
        -> AVAuthorizationStatus
    static func requestAccess(for mediaType: AVMediaType) async -> Bool
}

extension AVCaptureDevice: CameraPermissionManager { }
