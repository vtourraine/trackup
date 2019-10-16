//
//  main.swift
//  Trackup
//
//  Created by Vincent Tourraine on 16/10/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

import Foundation
import TrackupCore

if CommandLine.arguments.count >= 2 {
    let pathArgument = CommandLine.arguments[1]
    if FileManager.default.fileExists(atPath: pathArgument),
        let documentString = try? String(contentsOf: URL(fileURLWithPath: pathArgument)) {
        let document = TrackupParser().documentFromString(documentString)
        print("\(document)")
    }
    else {
        print("Invalid file")
    }
}
