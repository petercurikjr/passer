//
//  SixdigitCode.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 12/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import UIKit

///structure of sixdigitcode. Codable is an ability of struct to be encoded or decoded by json
struct JSONData: Codable {
    let sixdigitCode: String
    fileprivate let deviceID: String
    let timestamp: Date = Date()
}

func generateStruct() -> JSONData {
    
    //generate uuid of a device
    //let uuid = UIDevice.current.identifierForVendor?.uuidString
    let uuid = String(Int.random(in: 0 ... 1000))
    
    //generate sixdigitcode
    var sixdigitCode: [String] = []
    for _ in 0...5 {
        sixdigitCode.append(String(Int.random(in: 0 ... 9)))
    }
    let sixdigitJoined = sixdigitCode.joined()
    
    //create a JSONData instance and return
    let jsondata = JSONData(sixdigitCode: sixdigitJoined, deviceID: uuid)
    return jsondata

}

func activateValidCode() -> JSONData? {
    let sixdigitstructure = generateStruct()
    
    ///Convert to json and send
    guard let uploadData = try? JSONEncoder().encode(sixdigitstructure)
        else {
            return nil
        }
    postToServer(uploadData: uploadData);
    
    ///return the original Swift structure
    return sixdigitstructure
    
}






