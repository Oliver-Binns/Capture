@testable import Capture
import SwiftData
import XCTest

final class LensTests: XCTestCase {
    private var container: ModelContainer!

    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: Camera.self, Lens.self, Photo.self,
            configurations: config
        )
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    @MainActor
    func testStrings() {
        let lens = Lens(make: "Carl Zeiss",
                        model: "Planar 1,7/50",
                        maxAperture: 1.7,
                        minAperture: 16,
                        focalLength: 50)
        container.mainContext.insert(lens)

        XCTAssertEqual(lens.description, "Carl Zeiss Planar 1,7/50")
        XCTAssertEqual(lens.details, "ƒ/1.7 • 50mm")
    }
}
