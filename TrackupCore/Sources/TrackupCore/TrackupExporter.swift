//
//  TrackupExporter.swift
//  trackup
//
//  Created by Vincent Tourraine on 16 Oct 2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

import Foundation

public class TrackupExporter {
    var includeRoadmap = false
    var includeInProgressVersions = false

    public init() {
    }

    public func htmlPage(from document: TrackupDocument) -> String {
        var versionsStrings: [String] = []

        for version in document.versions {
            if (includeRoadmap == false && version.title == "Roadmap") {
                continue
            }

            if (includeInProgressVersions == false && version.inProgress()) {
                continue
            }

            var itemsStrings: [String] = []

            for item in version.items {
                let liClass = (item.status == .major) ? " class=\"major\"" : ""
                itemsStrings.append("<li\(liClass)>\(item.title)</li>\n")
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

                dateString = "<time datetime=\"\(year)-\(month)-\(day)\">\(formattedDateString)</time>"
            }

            let headerLevel = (version.title.components(separatedBy: ".").count >= 3) ? 3 : 2;

            versionsStrings.append("""
                <section>
                    <h\(headerLevel)>\(version.title)</h\(headerLevel)>
                    \(dateString)
                    <ul>\(itemsStrings.joined())</ul>
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
                    \(versionsStrings.joined())
                  </body>
                </html>
                """
    }
}
