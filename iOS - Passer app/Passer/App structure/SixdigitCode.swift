//
//  SixdigitCode.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 12/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import UIKit

///structure of sixdigitcode. Codable is an general ability of a struct to be encoded or decoded by json
struct SixdigitAuth: Codable {
    let sixdigitCode: String?
    fileprivate let deviceID: String
    let timestamp: Date?
}

func generateStruct() -> SixdigitAuth {
    
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
    let jsondata = SixdigitAuth(sixdigitCode: sixdigitJoined, deviceID: uuid, timestamp: Date())
    
    return jsondata

}

func sixdigitJSON(input: SixdigitAuth) -> Data? {
    ///Convert to json
    guard let json = try? JSONEncoder().encode(input)
        else {
            return nil
        }
    
    return json
}





