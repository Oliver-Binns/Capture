import AVFoundation
import Foundation
import SwiftUI

protocol ImageCaptureSession {
    func startPreview() -> AsyncStream<Image>
    func capture() -> Image
}

@Observable
@MainActor
final class CaptureViewModel {
    private(set) var authorizationStatus: AVAuthorizationStatus
    private(set) var isPreviewing: Bool = false
    private(set) var photo: Image? = nil
    private var cameraSession: ImageCaptureSession = CameraCaptureSession()
    
    var canCaptureVideo: Bool {
        switch authorizationStatus {
        case .notDetermined, .authorized:
            true
        case .restricted, .denied:
            false
        @unknown default:
            false
        }
    }
    
    init() {
        self.authorizationStatus = AVCaptureDevice
            .authorizationStatus(for: .video)
    }
    
    func takeOrResetPhoto() {
        guard isPreviewing else {
            photo = nil
            startPhotoOutput()
            return
        }
        isPreviewing = false
        photo = cameraSession.capture()
    }
    
    private func startPhotoOutput() {
        guard authorizationStatus != .notDetermined else {
            requestAuthorization()
            return
        }
        Task {
            isPreviewing = true
            for await photo in cameraSession.startPreview() {
                self.photo = photo
            }
        }
    }
    
    private func requestAuthorization() {
        Task {
            _ = await AVCaptureDevice.requestAccess(for: .video)
            authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            startPhotoOutput()
        }
    }
    
    private func capturePhoto() {
        print("capture photo")
    }
}
