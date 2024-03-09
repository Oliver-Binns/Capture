import AVFoundation
import SwiftUI

final class CameraCaptureSession {
    private let captureSession = AVCaptureSession()
    
    private var continuation: AsyncStream<Image>.Continuation?
}

extension CameraCaptureSession: ImageCaptureSession {
    func startPreview() -> AsyncStream<Image> {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(Image(systemName: "eraser"))
        }
    }
    
    func capture() -> Image {
        continuation?.finish()
        return Image(systemName: "pencil")
    }
}
