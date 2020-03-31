//
//  SixdigitCode.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 12/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

//structure of sixdigitcode. Codable is ability of struct to be encoded or decoded by json
struct JSONData: Codable {
    let data: String?
    let timestamp: String?
}

func generateSixDigitCodeData() -> JSONData {

    //generate timestamp
    let generateDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = formatter.string(from: generateDate)
    
    //generate sixdigitcode
    var sixdigitCode: [String] = []
    for _ in 0...5 {
        sixdigitCode.append(String(Int.random(in: 0 ... 9)))
    }
    let sixdigitJoined = sixdigitCode.joined()
    let jsondata = JSONData(data: sixdigitJoined, timestamp: date)
    
    return jsondata

}




