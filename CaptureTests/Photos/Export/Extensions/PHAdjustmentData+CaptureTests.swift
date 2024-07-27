@testable import Capture
import Photos
import XCTest

final class PHAdjustmentDataTests: XCTestCase {
    func testInitialiser() throws {
        let data = Data("information".utf8)
        let adjustment = PHAdjustmentData(data: data)
        XCTAssertEqual(adjustment.data, data)
        XCTAssertEqual(adjustment.formatIdentifier, "uk.co.oliverbinns.capture")
        XCTAssertEqual(adjustment.formatVersion, "1.0.0")
    }
}
