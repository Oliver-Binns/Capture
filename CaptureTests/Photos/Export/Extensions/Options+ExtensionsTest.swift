@testable import Capture
import Photos
import XCTest

final class OptionsTests: XCTestCase {
    func testNetworkAllowed() {
        XCTAssertTrue(
            PHContentEditingInputRequestOptions.networkAllowed
                .isNetworkAccessAllowed
        )
    }
}
