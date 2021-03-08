//
//  Identity.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import Foundation

enum Gender: String, Codable {
    case male
    case female
    case unspecified
}

final class Identity: Codable {
    internal var id: UUID = UUID()
    internal var firstName: String?
    internal var lastName: String?
    internal var email: String?
    internal var birthDate: Date?
    internal var username: String?
    internal var updatedAt: Date = Date()
    internal var gender: Gender?
    internal var address: Address?
    
    init(
        firstName: String,
        lastName: String,
        email: String,
        birthDate: Date,
        username: String,
        gender: Gender,
        address: Address
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthDate = birthDate
        self.username = username
        self.gender = gender
        self.address = address
    }
}
