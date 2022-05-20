import XCTest
@testable import TrackupCore

final class TrackupCoreTests: XCTestCase {
    func testBasicParsing() {
        let parser = TrackupParser()
        let string = """
            # Test

            http://www.website.com

            ## 1.0

            - [ ] Thing
            - [x] Stuff
            """
        let document = parser.documentFromString(string)
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

    func testHTMLFormatting() throws {
        let parser = TrackupParser()
        let string = """
            # Test

            http://www.website.com

            ## 1.1

            - [ ] Thing
            - [x] Stuff

            ## 1.0.1

            - Other

            ## 1.0

            2021-06-03

            - Thing
            - Stuff
            """
        let document = parser.documentFromString(string)
        let exporter = TrackupExporter()
        let html = exporter.htmlPage(from: document)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 3
        let date = try XCTUnwrap(Calendar.current.date(from: dateComponents))
        let localizedDate = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)

        let expectedHTML = """
            <html>
              <head>
                <meta charset="utf-8">
                <title>Test - Release Notes</title>
                <meta name="generator" content="Trackup Editor">
                <meta name="viewport" content="width=device-width">
                <link href="http://www.website.com/releasenotes" rel="canonical">
                <style>
                  body {font-family: -apple-system; padding-bottom: 80px; padding-left: 10px; padding-right: 10px;}
                  body > * {max-width:600px; margin-left: auto; margin-right: auto;}
                  h1 {margin-top: 80px; margin-bottom: 4px;}
                  h2 {margin-top: 40px; margin-bottom: 4px;}
                  time {color: #888;}
                  ul {padding-left: 20px;}
                  li.major {font-weight: bold;}
                </style>
              </head>
              <body>
                <h1>Test Release Notes</h1>
                <div><a href="http://www.website.com">http://www.website.com</a></div>
                <section>
                  <h3>1.0.1</h3>
                  <ul>
                    <li>Other</li>
                  </ul>
                </section>
                <section>
                  <h2>1.0</h2>
                  <time datetime="2021-6-3">\(localizedDate)</time>
                  <ul>
                    <li>Thing</li>
                    <li>Stuff</li>
                  </ul>
                </section>
              </body>
            </html>
            """

        XCTAssertEqual(html, expectedHTML)
    }

    func testJSONExport() throws {
        let document = TrackupDocument(title: "t1", versions: [], website: URL(string: "https://www.web.site")!)
        let exporter = TrackupExporter()
        let json = try XCTUnwrap(exporter.json(from: document))
        let expectedJSON = """
            {"title":"t1","website":"https:\\/\\/www.web.site","versions":[]}
            """
        XCTAssertEqual(json, expectedJSON)
    }

    static var allTests = [
        ("testBasicParsing", testBasicParsing),
    ]
}
