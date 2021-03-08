//
//  IdentityJson.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import UIKit

struct IdentityStruct: Codable {
    let address: Address?
    let birthdate: Date?
    let email: String?
    let email_verified: Bool?
    let family_name: String?
    let gender: Gender?
    let given_name: String?
    let locale: String?
    let middle_name: String?
    let name: String?
    let nickname: String
    let phone_number: String?
    let phone_number_verified: Bool?
    let picture: String?
    let preferred_username: String?
    let profile: String?
    let updated_at: Date?
    let website: String?
    let zoneinfo: String?
}

struct Address: Codable {
    let country: String?
    let formatted: String?
    let locality: String?
    let postal_code: String?
    let region: String?
    let street_address: String?
}

struct JSONWrapper: Codable {
    let account: IdentityStruct
    let device: Device
}

struct Device: Codable {
    let deviceId: String
}

func generatePasserIdentityStruct() -> JSONWrapper {
    //let deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    let deviceID = "49015420323751"
    let device = Device(deviceId: deviceID)
    let address = Address(country: "SK", formatted: nil, locality: nil, postal_code: nil, region: nil, street_address: nil)
    let identity = IdentityStruct(address: address, birthdate: nil, email: nil, email_verified: nil, family_name: nil, gender: nil, given_name: nil, locale: nil, middle_name: nil, name: nil, nickname: "funde luka", phone_number: nil, phone_number_verified: nil, picture: nil, preferred_username: nil, profile: nil, updated_at: nil, website: nil, zoneinfo: nil)
    
    return JSONWrapper(account: identity, device: device)
}

func identityToJSON(identity: JSONWrapper) -> Data? {
    guard let json = try? JSONEncoder().encode(identity)
        else {
            return nil
        }
    
    print(String(data: json, encoding: String.Encoding.utf8)!)
    
    return json
}
