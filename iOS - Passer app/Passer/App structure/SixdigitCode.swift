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
    let passwordItems: [PasswordItem]?
    let bankCardItems: [BankCardItem]?
    let otherItems: [OtherItem]?
}

func generatePasserItemsStruct(passwordItems: [PasswordItem]?, bankCardItems: [BankCardItem]?, otherItems: [OtherItem]?) -> SixdigitAuth {
    ///Generate uuid of a device
    let uuid = (UIDevice.current.identifierForVendor?.uuidString)!
    
    ///Create a SixdigitAuth instance and return
    let jsondata = SixdigitAuth(deviceID: uuid, passwordItems: passwordItems, bankCardItems: bankCardItems, otherItems: otherItems)
    
    return jsondata
}

func sixdigitToJSON(input: SixdigitAuth) -> Data? {
    ///Convert the generated struct to json
    guard let json = try? JSONEncoder().encode(input)
        else {
            return nil
        }
    
    print(String(data: json, encoding: String.Encoding.utf8)!)
    
    return json
}






