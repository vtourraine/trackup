//
//  main.swift
//  Trackup
//
//  Created by Vincent Tourraine on 16/10/2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

import Foundation
import TrackupCore

if CommandLine.arguments.count >= 2 {
    let pathArgument = CommandLine.arguments[1]
    if FileManager.default.fileExists(atPath: pathArgument),
        let documentString = try? String(contentsOf: URL(fileURLWithPath: pathArgument)) {
        let document = TrackupParser().documentFromString(documentString)
        let exporter = TrackupExporter()

        if CommandLine.arguments.count >= 3 && CommandLine.arguments[2] == "-html" {
            print("\(exporter.htmlPage(from: document))")
        }
        else if CommandLine.arguments.count >= 3 && CommandLine.arguments[2] == "-rss" {
            print("\(exporter.rss(from: document))")
        }
        else if CommandLine.arguments.count >= 3 && CommandLine.arguments[2] == "-json" {
            do {
                let json = try exporter.json(from: document)
                print("\(json)")
            }
            catch {
                print("Encoding error: \(error.localizedDescription)")
            }
        }
        else {
            print("\(document)")
        }
    }
    else {
        print("Invalid file")
    }
}
else {
    print("Command example: ./Trackup file.tu.md -html")
}
