import XCTest
@testable import TrackupCore

final class TrackupCoreTests: XCTestCase {
    func testBasicParsing() {
        let parser = TrackupParser()
        let document = parser.documentFromString("# Test\n\nhttp://www.website.com\n\n## 1.0\n\n- [ ] Thing\n- [x] Stuff\n")
        XCTAssertEqual(document.title, "Test")
        XCTAssertEqual(document.website, URL(string: "http://www.website.com"))
        XCTAssertEqual(document.versions.count, 1)
        XCTAssertEqual(document.versions[0].title, "1.0")
        XCTAssertTrue(document.versions[0].inProgress())
        XCTAssertEqual(document.versions[0].items.count, 2)
        XCTAssertEqual(document.versions[0].items[0].title, "Thing")
        XCTAssertEqual(document.versions[0].items[0].state, .todo)
        XCTAssertEqual(document.versions[0].items[0].status, .unknown)
        XCTAssertEqual(document.versions[0].items[1].title, "Stuff")
        XCTAssertEqual(document.versions[0].items[1].state, .done)
        XCTAssertEqual(document.versions[0].items[1].status, .unknown)
    }

    static var allTests = [
        ("testBasicParsing", testBasicParsing),
    ]
}
