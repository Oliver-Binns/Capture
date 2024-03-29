@testable import Capture
import XCTest

final class CaptureViewModelTests: XCTestCase {
    var sut: CaptureViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        
        sut = CaptureViewModel(
            cameraPermissionManager: MockCameraPermissionManager.self
        )
    }
    
    @MainActor
    func testCorrectlyFetchesPermissions() {
        XCTAssertEqual(MockCameraPermissionManager.didCheckAuthorizationStatus, .video)
        XCTAssertEqual(sut.authorizationStatus, .notDetermined)
        
        MockCameraPermissionManager.authorizationStatus = .authorized
        sut = CaptureViewModel(cameraPermissionManager: MockCameraPermissionManager.self)
        XCTAssertEqual(sut.authorizationStatus, .authorized)
    }
}
