//
//  SixdigitCode.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 12/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import UIKit

///Structure of six-digit code. Codable is an general ability of a struct to be encoded or decoded by json
struct SixdigitAuth: Codable {
    fileprivate let deviceID: String
    let sixdigitCode: String?
    let passwordItems: [PasswordItem]?
    let bankCardItems: [BankCardItem]?
    let otherItems: [OtherItem]?
    let timestamp: Date? ///Not processed by the server. This information is used only for internal purposes (timer countdown in the iOS app)
}

func generateStruct(passwordItems: [PasswordItem]?, bankCardItems: [BankCardItem]?, otherItems: [OtherItem]?) -> SixdigitAuth {
    ///Generate uuid of a device
    let uuid = (UIDevice.current.identifierForVendor?.uuidString)!
    //let uuid = String(Int.random(in: 0 ... 1000))
    
    ///Generate sixdigitcode
    var sixdigitCode: [String] = []
    for _ in 0...5 {
        sixdigitCode.append(String(Int.random(in: 0 ... 9)))
    }
    let sixdigitJoined = sixdigitCode.joined()
    
    ///Create a SixdigitAuth instance and return
    let jsondata = SixdigitAuth(deviceID: uuid, sixdigitCode: sixdigitJoined, passwordItems: passwordItems, bankCardItems: bankCardItems, otherItems: otherItems, timestamp: Date())
    
    return jsondata

}

func sixdigitJSON(input: SixdigitAuth) -> Data? {
    ///Convert the generated struct to json
    guard let json = try? JSONEncoder().encode(input)
        else {
            return nil
        }
    
    return json
}






