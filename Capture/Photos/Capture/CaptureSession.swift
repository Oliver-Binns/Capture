import AVFoundation

protocol CaptureSession: AnyObject {
    associatedtype DeviceInput
    associatedtype DeviceOutput
    
    var sessionPreset: AVCaptureSession.Preset { get set }
    
    func beginConfiguration()
    func commitConfiguration()
    
    var isRunning: Bool { get }
    func startRunning()
    func stopRunning()
    
    func canAddInput(_ input: DeviceInput) -> Bool
    func addInput(_ input: DeviceInput)
    
    func canAddOutput(_ output: DeviceOutput) -> Bool
    func addOutput(_ output: DeviceOutput)
}

extension AVCaptureSession: CaptureSession { }
