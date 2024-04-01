import AVFoundation
@testable import Capture

final class MockCameraPermissionManager: CameraPermissionManager {
    private(set) static var didCheckAuthorizationStatus: AVMediaType?
    static var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    private(set) static var didRequestAccess: AVMediaType?
    static var shouldAllowAccess: Bool = true
    
    static func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        didCheckAuthorizationStatus = mediaType
        return authorizationStatus
    }
    
    static func requestAccess(for mediaType: AVMediaType) async -> Bool {
        self.didRequestAccess = mediaType
        return shouldAllowAccess
    }
}
