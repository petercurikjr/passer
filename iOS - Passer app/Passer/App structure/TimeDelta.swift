//
//  TimeDelta.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 10/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

func timeDelta(initial: Date) -> [String] {
    
    var addZero: Bool = false
    
    ///2 minute time starter (in seconds)
    let countdown = 5
    let formatter = DateFormatter()
    formatter.dateFormat = "mm:ss"
    
    let timedelta = (countdown - Int(initial.timeIntervalSinceNow*(-1)))
    if timedelta <= 0 {
        return ["00","00"]
    }
    
    let seconds = timedelta % 60
    let minutes = Int(timedelta / 60)
    
    if seconds < 10 {
        addZero = true
    }
    
    return [String("0" + String(minutes)),
            addZero ? String("0" + String(seconds)) : String(seconds)]
}

func didItEnd(time: [String]) -> Bool {
    
    guard time[0].contains("00"),
          time[1].contains("00")
        else {
            return false
    }
    
    return true
}
