//
//  TrackupDocument.swift
//  trackup
//
//  Created by Vincent Tourraine on 29/11/16.
//  Copyright © 2016-2022 Studio AMANgA. All rights reserved.
//

import Foundation

struct K {
    static let roadmapTitle = "Roadmap"
}

public struct TrackupDocument: Codable {
    public var title: String = ""
    public var versions: [TrackupVersion] = []
    public var website: URL?
}

public struct TrackupVersion: Codable {
    public var title: String = ""
    public var items: [TrackupItem] = []
    public var createdDate: DateComponents?

    func inProgress() -> Bool {
        for item in self.items {
            if (item.state != .unknown) {
                return true
            }
        }

        return false
    }
}

public struct TrackupItem: Codable {
    public var title: String = ""
    public var state: TrackupItemState = .unknown
    public var status: TrackupItemStatus = .unknown
}

public enum TrackupItemState: String, Codable {
    case unknown
    case todo
    case done
}

public enum TrackupItemStatus: String, Codable {
    case unknown
    case major
}
