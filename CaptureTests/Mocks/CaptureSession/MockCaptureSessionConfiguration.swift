import AVFoundation
@testable import Capture

struct MockCaptureSessionConfiguration: CaptureSessionConfiguration {
    let session: MockCaptureSession

    func input() throws -> MockCaptureSession.MockDeviceInput? {
        .init()
    }

    func output(delegate: AVCaptureVideoDataOutputSampleBufferDelegate?) -> MockCaptureSession.MockDeviceOutput {
        .init()
    }
}
