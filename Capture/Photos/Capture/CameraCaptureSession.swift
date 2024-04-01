import AVFoundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

final class CameraCaptureSession<Configuration: CaptureSessionConfiguration>: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let configuration: Configuration
    private var captureSession: Configuration.CS {
        configuration.session
    }
    
    private let sessionQueue: DispatchQueue
    
    private var deviceInput: Configuration.CS.DeviceInput?
    private var videoOutput: Configuration.CS.DeviceOutput?
    private var isCaptureSessionConfigured: Bool = false
    
    private var continuation: AsyncStream<CIImage>.Continuation?
    
    init(configuration: Configuration = AVCaptureSessionConfiguration(),
         sessionQueue: DispatchQueue = DispatchQueue(label: "session queue", qos: .userInitiated)) {
        self.configuration = configuration
        self.sessionQueue = sessionQueue
        super.init()
    }
    
    private func resumeVideoCapture() {
        sessionQueue.async { [self] in
            if !isCaptureSessionConfigured {
                configureCaptureSession()
            }
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
    }
    
    private func configureCaptureSession() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        guard let deviceInput = try? configuration.input() else {
            return
        }

        guard let delegate = self as? Configuration.Delegate else {
            preconditionFailure("Expected CameraCaptureSession to be a delegate of CaptureSessionConfiguration")
        }
        let videoOutput = configuration.output(delegate: delegate)
  
        guard captureSession.canAddInput(deviceInput),
              captureSession.canAddOutput(videoOutput) else {
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
        self.videoOutput = videoOutput
        
        isCaptureSessionConfigured = true
        
        captureSession.commitConfiguration()
    }
    
    private func closeCaptureSession() {
        guard isCaptureSessionConfigured else { return }
        
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

        if connection.isVideoOrientationSupported,
           let videoOrientation = videoOrientation() {
            connection.videoOrientation = videoOrientation
        }

        let image = CIImage(cvPixelBuffer: pixelBuffer)
        continuation?.yield(image)
    }
    
    #if canImport(UIKit)
    private func videoOrientation(_ deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation) -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: return AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight: return AVCaptureVideoOrientation.landscapeLeft
        default: return nil
        }
    }
    #else
    private func videoOrientation() -> AVCaptureVideoOrientation? {
        .portrait
    }
    #endif
}

extension CameraCaptureSession: ImageCaptureSession {
    func startPreview() -> AsyncStream<CIImage> {
        AsyncStream { continuation in
            resumeVideoCapture()
            self.continuation = continuation
        }
    }
    
    func stopPreview() {
        continuation?.finish()
        continuation = nil
        
        closeCaptureSession()
    }
}
