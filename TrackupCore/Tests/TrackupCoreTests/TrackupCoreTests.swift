import XCTest
@testable import TrackupCore

final class TrackupCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TrackupCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
