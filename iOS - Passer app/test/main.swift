//
//  main.swift
//  test
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

var sixdigitCode = ["1","2","3","4","5","6"]
var codeJoined = sixdigitCode.joined()
sixdigitCode.append("4")

var paths: [URL]?
var path: URL?
path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let filenames = ["a.txt","b.txt","c.txt"]

for i in 0...2 {
    if path == nil {
        print("Couldn't find a place for Passer app data. Error in \(i). file")
    }
    else {
        paths?.append(path!)
        paths![i].appendPathComponent(filenames[i])
    }
}

