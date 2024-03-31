@testable import Capture
import CoreImage
import XCTest

final class CIImageExtensionsTests: XCTestCase {
    func testExportOptions() {
        XCTAssertEqual(
            CIImage().exportOptions.count,
            1
        )
        
        XCTAssertEqual(
            CIImage().exportOptions[kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption] as? Double,
            0.7
        )
    }
}
