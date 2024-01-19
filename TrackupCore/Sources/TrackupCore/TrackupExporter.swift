//
//  TrackupExporter.swift
//  trackup
//
//  Created by Vincent Tourraine on 16 Oct 2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

import Foundation

public class TrackupExporter {
    var includeRoadmap = false
    var includeInProgressVersions = false

    public init() {
    }

    private func filteredDocument(_ document: TrackupDocument) -> TrackupDocument {
        var filteredVersions = document.versions

        if !includeRoadmap {
            filteredVersions = filteredVersions.filter { $0.title != K.roadmapTitle }
        }

        if !includeInProgressVersions {
            filteredVersions = filteredVersions.filter { !$0.inProgress() }
        }

        return TrackupDocument(title: document.title, versions: filteredVersions, website: document.website)
    }

    public func json(from document: TrackupDocument) throws -> String {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(filteredDocument(document))
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        else {
            return ""
        }
    }

    public func rss(from document: TrackupDocument) -> String {
        let filteredDocument = filteredDocument(document)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        dateFormatter.timeZone = calendar.timeZone

        let items = filteredDocument.versions.compactMap { version in
            guard let createdDate = version.createdDate,
                  let date = calendar.date(from: createdDate) else {
                return nil
            }

            return """
                    <item>
                      <title>\(version.title)</title>
                      <description>\(version.items.map { "• \($0.title)" }.joined(separator: "\n"))</description>
                      <pubDate>\(dateFormatter.string(from: date))</pubDate>
                      <guid>\(document.website?.absoluteString ?? "")/\(version.title)</guid>
                    </item>
                """
        }.joined(separator: "\n")

        return """
            <?xml version="1.0"?>
            <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
              <channel>
                <title>\(document.title)</title>
                <link>\(document.website?.absoluteString ?? "")</link>
                <description>Version history for \(document.title)</description>
                <generator>Trackup</generator>
                <atom:link href="\(document.website?.absoluteString ?? "")/releasenotes.xml" rel="self" type="application/rss+xml" />
            \(items)
              </channel>
            </rss>

            """
    }

    public func htmlPage(from document: TrackupDocument) -> String {
        var versionsStrings: [String] = []
        let filteredDocument = filteredDocument(document)

        for version in filteredDocument.versions {
            var itemsStrings: [String] = []

            for item in version.items {
                let liClass = (item.status == .major) ? " class=\"major\"" : ""
                itemsStrings.append("        <li\(liClass)>\(item.title)</li>\n")
            }

            var dateString = ""
            let calendar = NSCalendar.current
            if let createdDateComponents = version.createdDate,
                let date = calendar.date(from: createdDateComponents),
                let year = createdDateComponents.year,
                let month = createdDateComponents.month,
                let day = createdDateComponents.day {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                let formattedDateString = dateFormatter.string(from: date)

                dateString = "      <time datetime=\"\(year)-\(month)-\(day)\">\(formattedDateString)</time>\n"
            }

            let headerLevel = (version.title.components(separatedBy: ".").count >= 3) ? 3 : 2;

            versionsStrings.append("""
                    <section>
                      <h\(headerLevel)>\(version.title)</h\(headerLevel)>\n
                """)

            if !dateString.isEmpty {
                versionsStrings.append(dateString)
            }

            versionsStrings.append("""
                      <ul>
                \(itemsStrings.joined())\
                      </ul>
                    </section>\n
                """)
        }

        let websiteTag: String
        let canonicalTag: String
        if let websiteURL = document.website {
            websiteTag = "<div><a href=\"\(websiteURL.absoluteString)\">\(websiteURL.absoluteString)</a></div>"
            canonicalTag = "<link href=\"\(websiteURL.absoluteString)/releasenotes\" rel=\"canonical\">"
        }
        else {
            websiteTag = ""
            canonicalTag = ""
        }

        return """
                <html>
                  <head>
                    <meta charset=\"utf-8\">
                    <title>\(document.title) - Release Notes</title>
                    <meta name=\"generator\" content=\"Trackup Editor\">
                    <meta name=\"viewport\" content=\"width=device-width\">
                    \(canonicalTag)
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
                    <h1>\(document.title) Release Notes</h1>
                    \(websiteTag)
                \(versionsStrings.joined())\
                  </body>
                </html>
                """
    }
}
