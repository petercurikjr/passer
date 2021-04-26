//
//  IdentityJson.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import SocketIO

protocol Loopable {
    func allProperties() -> [String: String?]
}

extension Loopable {
    func allProperties() -> [String: String?] {
        var result: [String: String?] = [:]
        let mirror = Mirror(reflecting: self)

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value as? String
        }

        return result
    }
}

struct IdentityStruct: SocketData, Loopable {
    let address: Address?
    let birthdate: String?
    let email: String?
    let email_verified: Bool?
    let family_name: String?
    let gender: Gender?
    let given_name: String?
    let locale: String?
    let middle_name: String?
    let name: String?
    let nickname: String?
    let phone_number: String?
    let phone_number_verified: Bool?
    let picture: String?
    let preferred_username: String?
    let profile: String?
    let updated_at: Date?
    let website: String?
    let zoneinfo: String?
    
    func socketRepresentation() -> SocketData {
        let identityDict = self.allProperties()
        let addressDict = self.address?.allProperties()
        
        let idNotNil = identityDict.compactMapValues{$0}
        let addrNotNil = addressDict?.compactMapValues{$0}
        
        var idNotNilAny = idNotNil as [String: Any]
        idNotNilAny["address"] = addrNotNil
                
        return ["account": idNotNilAny]
    }
}

struct Address: Loopable, Codable {
    let country: String?
    let formatted: String?
    let locality: String?
    let postal_code: String?
    let region: String?
    let street_address: String?
}

func generatePasserIdentityStruct(identity: Identity, selectedItems: [Int]) -> IdentityStruct {
    var attrVals = [
        identity.firstName,                 //0
        identity.lastName,                  //1
        identity.username,                  //2
        identity.birthDate,                 //3
        identity.gender,                    //4
        identity.email,                     //5
        identity.phoneNumber,               //6
        identity.address?.street_address,   //7
        identity.address?.locality,         //8
        identity.address?.postal_code,      //9
        identity.address?.country,          //10
        identity.nickname,                  //11
        identity.middleName                 //12
    ] as [Any?]

    for i in 0..<attrVals.count {
        if !selectedItems.contains(i) {
            attrVals[i] = nil
        }
    }
    
    let address = Address(
        country: attrVals[10] as? String,
        formatted: nil,
        locality: attrVals[8] as? String,
        postal_code: attrVals[9] as? String,
        region: nil,
        street_address: attrVals[7] as? String
    )
    
    let date = identity.convertDate(date: attrVals[3] as? Date ?? nil, mode: .dashed)
    //let updatedAt = identity.convertDate(date: identity.updatedAt, mode: .dashed)
    let name = (attrVals[0] as? String ?? "") + ((attrVals[1] != nil ? " " : "") + (attrVals[1] as? String ?? ""))
    
    return IdentityStruct(
        address: address,
        birthdate: date,
        email: attrVals[5] as? String,
        email_verified: nil,
        family_name: nil,
        gender: attrVals[4] as? Gender,
        given_name: nil,
        locale: nil,
        middle_name: attrVals[12] as? String,
        name: name,
        nickname: attrVals[11] as? String,
        phone_number: attrVals[6] as? String,
        phone_number_verified: nil,
        picture: nil,
        preferred_username: attrVals[2] as? String,
        profile: nil,
        updated_at: nil/*identity.updatedAt*/,
        website: nil,
        zoneinfo: nil
    )
}


func generatePasserIdentityStruct(identity: Identity? = nil, selectedItems: [Int]? = nil) -> IdentityStruct {
    return generatePasserIdentityStruct(identity: identity!, selectedItems: selectedItems!)
}
