import AVFoundation

protocol CaptureSessionConfiguration {
    associatedtype CS: CaptureSession
    associatedtype Delegate

    var session: CS { get }
    func input() throws -> CS.DeviceInput?
    func output(delegate: Delegate?) -> CS.DeviceOutput
}

struct AVCaptureSessionConfiguration: CaptureSessionConfiguration {
    let session = AVCaptureSession()

    func input() throws -> AVCaptureInput? {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        return try AVCaptureDeviceInput(device: device)
    }

    func output(delegate: AVCaptureVideoDataOutputSampleBufferDelegate?) -> AVCaptureOutput {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        return output
    }
}
