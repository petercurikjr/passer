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
print(sixdigitCode[6])

// To convert the date into an HH:mm format
func findDateDiff(time1Str: String, time2Str: String) -> String {
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = "hh:mm"

    guard let time1 = timeformatter.date(from: time1Str),
        let time2 = timeformatter.date(from: time2Str) else { return "" }

    //You can directly use from here if you have two dates

    let interval = time2.timeIntervalSince(time1)
    //let hour = interval / 3600;
    //let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
    //return "\(Int(hour))h \(Int(minute))s"
    return String(interval)
}

let dateDiff = findDateDiff(time1Str: "09:54", time2Str: "9:56")


let formatter = DateFormatter()
formatter.dateFormat = "mm:ss"
let seconds = Date().timeIntervalSince(initial)
let minutes = seconds / 60
