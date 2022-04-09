//
//  TrackupParser.swift
//  trackup
//
//  Created by Vincent Tourraine on 29/11/16.
//  Copyright © 2016-2018 Studio AMANgA. All rights reserved.
//

import Foundation

open class TrackupParser {

    let TrackupDocumentTitlePrefix = "# "
    let TrackupDocumentURLPrefix = "http"
    let TrackupVersionTitlePrefix = "## "
    let TrackupItemPrefix = "- "
    let TrackupItemDonePrefix = "[x]"
    let TrackupItemTodoPrefix = "[ ]"
    let TrackupItemMajorMarkers = "**"

    public init() {
    }

    open func documentFromString(_ string: String) -> TrackupDocument {
        var document = TrackupDocument()
        let lines = string.components(separatedBy: NSCharacterSet.newlines)

        var currentVersion: TrackupVersion?
        var versions: [TrackupVersion] = []
        var currentItems: [TrackupItem] = []

        for line in lines {
            if line.hasPrefix(TrackupDocumentTitlePrefix) {
                document.title = String(line.suffix(from: TrackupDocumentTitlePrefix.endIndex))
            }
            else if line.hasPrefix(TrackupVersionTitlePrefix) {
                if currentVersion != nil {
                    currentVersion!.items = currentItems
                    versions.append(currentVersion!)
                }

                currentVersion = TrackupVersion()
                currentVersion?.title = String(line.suffix(from: TrackupVersionTitlePrefix.endIndex))
                currentItems = []
            }
            else if line.hasPrefix(TrackupItemPrefix) {
                var item = TrackupItem()
                var title = String(line.suffix(from: TrackupItemPrefix.endIndex))

                if title.hasPrefix(TrackupItemTodoPrefix) {
                    item.state = .todo
                    title = String(title.suffix(from: TrackupItemTodoPrefix.endIndex))
                }
                else if title.hasPrefix(TrackupItemDonePrefix) {
                    item.state = .done
                    title = String(title.suffix(from: TrackupItemDonePrefix.endIndex))
                }

                if title.hasPrefix(TrackupItemMajorMarkers) && title.hasSuffix(TrackupItemMajorMarkers) {
                    item.status = .major
                    let location = TrackupItemMajorMarkers.endIndex
                    let end = title.index(title.endIndex, offsetBy: -TrackupItemMajorMarkers.count)
                    title = String(title[location ..< end])
                }

                item.title = title.trimmingCharacters(in: .whitespacesAndNewlines);
                currentItems.append(item)
            }
            else if line.hasPrefix(TrackupDocumentURLPrefix) && document.website == nil {
                document.website = URL(string: line)
            }
            else if line.components(separatedBy: "-").count == 3 {
                let components = line.components(separatedBy: "-")
                var dateComponents = DateComponents()
                dateComponents.year = Int(components[0])!
                dateComponents.month = Int(components[1])!
                dateComponents.day = Int(components[2])!
                currentVersion?.createdDate = dateComponents
            }
        }

        if currentVersion != nil {
            currentVersion?.items = currentItems
            versions.append(currentVersion!)
        }

        document.versions = versions
        
        return document
    }
}
