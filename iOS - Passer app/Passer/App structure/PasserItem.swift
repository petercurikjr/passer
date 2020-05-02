//
//  Password.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import CryptoKit
             
protocol PasserItem {
    var id: UUID { get }
    var itemname: String { get set }
    var group: Int? { get set }
    var favourites: Bool? { get set }
    
    func getItemName() -> String
    func setItemName(itemname: String)
    func getGroup() -> Int?
    func setGroup(group: Int)
    func getFavourites() -> Bool?
    func setFavourites(favourites: Bool)
}

final class PasswordItem: Identifiable, Codable, Equatable, PasserItem {
    internal var id: UUID = UUID()
    internal var itemname: String
    internal var group: Int?
    internal var favourites: Bool?
    
    private var username: String?
    private var password: String
    private var url: String?
    
    init(username: String?, password: String, url: String?,
         itemname: String, group: Int?, favourites: Bool) {
        self.itemname = itemname
        self.group = group
        self.favourites = favourites
        
        self.username = username
        self.password = password
        self.url = url
    }

    static func == (lhs: PasswordItem, rhs: PasswordItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getUsername() -> String? { return self.username }
    func setUsername(itemname: String) { self.itemname = itemname }
    func getPassword() -> String { return self.password }
    func setPassword(password: String) { self.password = password }
    func getUrl() -> String? { return self.url }
    func setUrl(url: String) { self.url = url }
    
    func getItemName() -> String { return self.itemname }
    func setItemName(itemname: String) { self.itemname = itemname }
    func getGroup() -> Int? { return self.group }
    func setGroup(group: Int) { self.group = group }
    func getFavourites() -> Bool? { return self.favourites }
    func setFavourites(favourites: Bool) { self.favourites = favourites }
}

final class BankCardItem: Identifiable, Codable, Equatable, PasserItem  {
    internal var id = UUID()
    internal var itemname: String
    internal var group: Int?
    internal var favourites: Bool?
    
    private var cardNumber: String
    private var expireDate: String
    private var cvv: String
    private var pinNumber: String?
    
    init(cardNumber: String, expireDate: String, cvv: String, pinNumber: String?,
        itemname: String, group: Int?, favourites: Bool) {
        self.itemname = itemname
        self.group = group
        self.favourites = favourites
        
        self.cardNumber = cardNumber
        self.expireDate = expireDate
        self.cvv = cvv
        self.pinNumber = pinNumber
    }
    
    static func == (lhs: BankCardItem, rhs: BankCardItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getCardNumber() -> String { return self.cardNumber }
    func setCardNumber(cardNumber: String) { self.cardNumber = cardNumber }
    func getExpireDate() -> String { return self.expireDate }
    func setExpireDate(expireDate: String) { self.expireDate = expireDate }
    func getCvv() -> String { return self.cvv }
    func setCvv(cvv: String) { self.cvv = cvv }
    func getPin() -> String? { return self.pinNumber }
    func setPin(pin: String) { self.pinNumber = pin }
    
    func getItemName() -> String { return self.itemname }
    func setItemName(itemname: String) { self.itemname = itemname }
    func getGroup() -> Int? { return self.group }
    func setGroup(group: Int) { self.group = group }
    func getFavourites() -> Bool? { return self.favourites }
    func setFavourites(favourites: Bool) { self.favourites = favourites }
}

final class OtherItem: Identifiable, Codable, Equatable, PasserItem {
    internal var id = UUID()
    internal var itemname: String
    internal var group: Int?
    internal var favourites: Bool?
    
    private var field1: String?
    private var field2: String?
    private var field3: String?
    private var field4: String?
    
    init(field1: String?, field2: String?, field3: String?, field4: String?,
         itemname: String, group: Int?, favourites: Bool) {
        self.itemname = itemname
        self.group = group
        self.favourites = favourites
        
        self.field1 = field1
        self.field2 = field2
        self.field3 = field3
        self.field4 = field4
    }
    
    static func == (lhs: OtherItem, rhs: OtherItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getField1() -> String? { return self.field1 }
    func setField1(field1: String) { self.field1 = field1 }
    func getField2() -> String? { return self.field2 }
    func setField2(field2: String) { self.field2 = field2 }
    func getField3() -> String? { return self.field3 }
    func setField3(field3: String) { self.field3 = field3 }
    func getField4() -> String? { return self.field4 }
    func setField4(field4: String) { self.field4 = field4 }
    
    func getItemName() -> String { return self.itemname }
    func setItemName(itemname: String) { self.itemname = itemname }
    func getGroup() -> Int? { return self.group }
    func setGroup(group: Int) { self.group = group }
    func getFavourites() -> Bool? { return self.favourites }
    func setFavourites(favourites: Bool) { self.favourites = favourites }
}

