//
//  TrackupDocument.swift
//  trackup
//
//  Created by Vincent Tourraine on 29/11/16.
//  Copyright © 2016 Studio AMANgA. All rights reserved.
//

import Foundation

public struct TrackupDocument {
    public var title: String = ""
    public var versions: [TrackupVersion] = []
    public var website: URL?
}

public struct TrackupVersion {
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

public struct TrackupItem {
    public var title: String = ""
    public var state: TrackupItemState = .unknown
    public var status: TrackupItemStatus = .unknown
}

public enum TrackupItemState {
    case unknown
    case todo
    case done
}

public enum TrackupItemStatus {
    case unknown
    case major
}
