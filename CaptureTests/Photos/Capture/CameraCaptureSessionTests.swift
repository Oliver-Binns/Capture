import AVFoundation
@testable import Capture
import XCTest

final class CameraCaptureSessionTests: XCTestCase {
    private var sut: CameraCaptureSession<MockCaptureSessionConfiguration>!
    private var captureSession: MockCaptureSession!
    
    override func setUp() {
        super.setUp()
        
        captureSession = MockCaptureSession()
        let configuration = MockCaptureSessionConfiguration(session: captureSession)
        sut = CameraCaptureSession(configuration: configuration)
    }
    
    override func tearDown() {
        captureSession = nil
        sut = nil
        super.tearDown()
    }
    
    func testStartConfiguresCaptureSession() {
        _ = sut.startPreview()
        wait(for: self.captureSession.didBeginConfiguration)
        XCTAssertEqual(captureSession.sessionPreset, .photo)
        
        wait(for: self.captureSession.isRunning)
        XCTAssertEqual(captureSession.inputs.count, 1)
        XCTAssertEqual(captureSession.outputs.count, 1)
    }
    
    func testStopRunningFinishesYieldingValues() async {
        let stream = sut.startPreview()
        sut.stopPreview()
        
        for await _ in stream {
            XCTFail("Expected stream to be finished")
        }
    }
    
    func testStopRunningStopsCaptureSession() {
        _ = sut.startPreview()
        wait(for: self.captureSession.isRunning)
        
        sut.stopPreview()
        wait(for: !self.captureSession.isRunning)
    }
    
    func testCaptureOutputYieldsAValue() throws {
        let stream = sut.startPreview()
        
        let exp = expectation(description: "Wait for CIImage to be output")
        Task {
            for await _ in stream {
                exp.fulfill()
            }
        }
        
        let output = AVCaptureVideoDataOutput()
        let connection = AVCaptureConnection(inputPorts: [], output: output)
        sut.captureOutput(output,
                          didOutput: .mock,
                          from: connection)
        
        wait(for: [exp])
        sut.stopPreview()
    }
    
    func testRestartDoesntReconfigureSession() {
        _ = sut.startPreview()
        wait(for: self.captureSession.isRunning)
        XCTAssertTrue(captureSession.didBeginConfiguration)
        
        captureSession.reset()
        XCTAssertFalse(captureSession.didBeginConfiguration)
        XCTAssertFalse(captureSession.isRunning)
        
        _ = sut.startPreview()
        wait(for: self.captureSession.isRunning)
        XCTAssertFalse(captureSession.didBeginConfiguration)
    }
}
