//
//  Identity.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import Foundation

enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
    case unspecified = "Unspecified"
}

enum DateModes {
    case dashed
    case dotted
}

final class Identity: Codable, Identifiable {
    var id: UUID = UUID()
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var birthDate: Date?
    var username: String?
    var nickname: String?
    var middleName: String?
    var updatedAt: Date = Date()
    var gender: Gender?
    var address: Address?
    let attrKeys: [String]
    
    var basicInformationCategory = [[String?]]()
    var contactCategory = [[String?]]()
    var addressCategory = [[String?]]()
    
    init(
        firstName: String,
        lastName: String,
        middleName: String,
        email: String,
        phoneNumber: String,
        birthDate: Date,
        username: String,
        nickname: String,
        gender: Gender,
        address: Address
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.email = email
        self.phoneNumber = phoneNumber
        self.birthDate = birthDate
        self.username = username
        self.nickname = nickname
        self.gender = gender
        self.address = address
        
        self.attrKeys = ["First Name", "Last Name", "Username", "Birth Date", "Gender", "Email", "Phone Number", "Street", "City", "ZIP Code", "Country", "Nickname", "Middle Name"]
        
        self.basicInformationCategory = [
            ["title", "Basic information"],
            ["Username:", self.username],
            ["Gender:", self.gender?.rawValue],
            ["Birth date:", self.convertDate(date: self.birthDate, mode: .dotted)]
        ]
        
        self.contactCategory = [
            ["title", "Contact"],
            ["Mail:",self.email],
            ["Phone:",self.phoneNumber]
        ]
        
        self.addressCategory = [
            ["title","Address"],
            ["Street:",self.address?.street_address],
            ["Postal Code:",self.address?.postal_code],
            ["City:",self.address?.locality],
            ["Region:",self.address?.region],
            ["Country:",self.address?.country]
        ]
    }

    func convertDate(date: Date?, mode: DateModes) -> String {
        if date == nil {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = mode == .dashed ? "yyyy-dd-MM" : "dd.MM.yyyy"
        
        return dateFormatter.string(from: date!)
    }
}
