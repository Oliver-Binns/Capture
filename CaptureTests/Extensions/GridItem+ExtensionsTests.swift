@testable import Capture
import SwiftUI
import XCTest

final class GridItemTests: XCTestCase {
    func testThree() {
        XCTAssertEqual([GridItem].three.count, 3)
    }
}
