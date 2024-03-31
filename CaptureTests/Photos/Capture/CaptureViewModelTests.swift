import AVFoundation
@testable import Capture
import XCTest

final class CaptureViewModelTests: XCTestCase {
    var sut: CaptureViewModel!
    
    private var didCallStopPreview = false
    
    private var imageData: Data {
        get throws {
            let bundle = Bundle(for: CaptureViewModelTests.self)
            let url = try XCTUnwrap(
                bundle.url(forResource: "camera", withExtension: "jpg")
            )
            return try Data(contentsOf: url)
        }
    }
    
    private lazy var image: CIImage = {
        guard let image = try? CIImage(data: imageData) else {
            fatalError("Could not find image data in bundle")
        }
        return image
    }()
    
    @MainActor
    override func setUp() {
        super.setUp()
        
        createSUT(permissions: .notDetermined)
    }
    
    @MainActor
    func createSUT(permissions: AVAuthorizationStatus = .notDetermined) {
        MockCameraPermissionManager.authorizationStatus = permissions
        sut = CaptureViewModel(cameraPermissionManager: MockCameraPermissionManager.self,
                               captureSesion: self)
    }
    
    @MainActor
    func testInitialisation() {
        XCTAssertFalse(sut.isPreviewing)
        XCTAssertNil(sut.photo)
        XCTAssertNil(sut.data)
    }
    
    @MainActor
    func testCorrectlyFetchesPermissions() {
        XCTAssertEqual(MockCameraPermissionManager.didCheckAuthorizationStatus, .video)
        XCTAssertEqual(sut.authorizationStatus, .notDetermined)
        
        createSUT(permissions: .authorized)
        XCTAssertEqual(sut.authorizationStatus, .authorized)
    }
    
    @MainActor
    func testCanCaptureVideo() {
        createSUT(permissions: .notDetermined)
        XCTAssertTrue(sut.canCaptureVideo)
        
        createSUT(permissions: .denied)
        XCTAssertFalse(sut.canCaptureVideo)
        
        createSUT(permissions: .authorized)
        XCTAssertTrue(sut.canCaptureVideo)
        
        createSUT(permissions: .restricted)
        XCTAssertFalse(sut.canCaptureVideo)
    }
    
    @MainActor
    func testLoadFromStorage() throws {
        let data = try imageData
        sut.loadFromStorage(data: data)
        
        XCTAssertEqual(sut.data, data)
        XCTAssertNotNil(sut.photo)
    }
    
    func testTakeOrResetPhotoRequestsAuthorization() async throws {
        MockCameraPermissionManager.authorizationStatus = .authorized
        try await sut.takeOrResetPhoto()
        
        XCTAssertEqual(
            MockCameraPermissionManager.didRequestAccess,
            .video
        )
    }
    
    func testTakeOrResetPhotoStartsStreamIfAuthorized() async throws {
        MockCameraPermissionManager.authorizationStatus = .authorized
        try await sut.takeOrResetPhoto()
        
        let isPreviewing = await sut.isPreviewing
        XCTAssertTrue(isPreviewing)
    }
    
    func testTakeOrResetPhotoThrowsErrorIfDenied() async {
        MockCameraPermissionManager.authorizationStatus = .denied
        
        do {
            try await sut.takeOrResetPhoto()
            XCTFail("Expected error to be thrown")
        } catch CaptureError.unauthorized {
            
        } catch {
            XCTFail("Unexpected error, expected `CaptureError.unauthorized`")
        }
        
        let isPreviewing = await sut.isPreviewing
        XCTAssertFalse(isPreviewing)
    }
    
    func testTakeOrResetPhotoUpdatesPhotoStream() async throws {
        MockCameraPermissionManager.authorizationStatus = .authorized
        try await sut.takeOrResetPhoto()
        
        let data = await sut.data
        XCTAssertNotNil(data)
        
        let photo = await sut.photo
        XCTAssertNotNil(photo)
    }
}

extension CaptureViewModelTests: ImageCaptureSession {
    func startPreview() -> AsyncStream<CIImage> {
        AsyncStream { continuation in
            continuation.yield(image)
            continuation.finish()
        }
    }
    
    func stopPreview() {
        didCallStopPreview = true
    }
}
