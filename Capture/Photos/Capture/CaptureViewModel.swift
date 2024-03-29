import AVFoundation
import Foundation
import SwiftUI

protocol ImageCaptureSession {
    func startPreview() -> AsyncStream<CIImage>
    func stopPreview()
}

@Observable
@MainActor
final class CaptureViewModel {
    private var cameraPermissionManager: CameraPermissionManager.Type
    private(set) var authorizationStatus: AVAuthorizationStatus
    private(set) var isPreviewing: Bool = false
    private(set) var photo: Image? = nil
    private(set) var data: Data?
    
    private var captureSession: ImageCaptureSession
    
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
    
    init(cameraPermissionManager: CameraPermissionManager.Type = AVCaptureDevice.self,
         captureSesion: ImageCaptureSession = CameraCaptureSession()) {
        self.cameraPermissionManager = cameraPermissionManager
        self.authorizationStatus = cameraPermissionManager.authorizationStatus(for: .video)
        self.captureSession = captureSesion
    }
    
    func takeOrResetPhoto() {
        guard isPreviewing else {
            photo = nil
            startPhotoOutput()
            return
        }
        isPreviewing = false
        captureSession.stopPreview()
    }
    
    func loadFromStorage(data: Data) {
        self.photo = CIImage(data: data)?.image
        self.data = data
    }
    
    private func startPhotoOutput() {
        guard authorizationStatus != .notDetermined else {
            requestAuthorization()
            return
        }
        Task {
            isPreviewing = true
            for await photo in captureSession.startPreview() {
                self.photo = photo.image
                self.data = photo.data
            }
        }
    }
    
    private func requestAuthorization() {
        Task {
            _ = await cameraPermissionManager.requestAccess(for: .video)
            authorizationStatus = cameraPermissionManager.authorizationStatus(for: .video)
            startPhotoOutput()
        }
    }
}
