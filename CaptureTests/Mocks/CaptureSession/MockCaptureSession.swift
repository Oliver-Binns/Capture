import AVFoundation
@testable import Capture

final class MockCaptureSession: CaptureSession {
    var sessionPreset: AVCaptureSession.Preset = .low
    
    init() {
        
    }
    
    private(set) var didBeginConfiguration: Bool = false
    private(set) var didCommitConfiguration: Bool = false
    
    func beginConfiguration() {
        didBeginConfiguration = true
    }
    
    func commitConfiguration() {
        didCommitConfiguration = true
    }
    
    private(set) var isRunning: Bool = false
    
    func startRunning() {
        isRunning = true
    }
    
    func stopRunning() {
        isRunning = false
    }
    
    private(set) var inputs: [MockDeviceInput] = []
    
    func canAddInput(_ input: MockDeviceInput) -> Bool {
        true
    }
    
    func addInput(_ input: MockDeviceInput) {
        inputs.append(input)
    }
    
    private(set) var outputs: [MockDeviceOutput] = []
    
    func canAddOutput(_ output: MockDeviceOutput) -> Bool {
        true
    }
    
    func addOutput(_ output: MockDeviceOutput) {
        outputs.append(output)
    }
    
    typealias DeviceInput = MockDeviceInput
    typealias DeviceOutput = MockDeviceOutput
    
    struct MockDeviceInput { }
    struct MockDeviceOutput { }

    func reset() {
        inputs = []
        outputs = []
        
        didBeginConfiguration = false
        didCommitConfiguration = false
        
        isRunning = false
    }
}

