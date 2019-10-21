//
//  TrackupCoreBridge.swift
//  Trackup Editor
//
//  Created by Vincent Tourraine on 21/10/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

import Foundation
import TrackupCore

public class TrackupCoreBridge: NSObject {

    @objc public static func saveDocument(text: NSString, to fileURL: NSURL) {
        let parser = TrackupParser()
        let document = parser.documentFromString(text as String)
        let exporter = TrackupExporter()
        let html = exporter.htmlPage(from: document) as NSString
        try! html.write(to: fileURL as URL, atomically: true, encoding: String.Encoding.utf8.rawValue)
    }
}
