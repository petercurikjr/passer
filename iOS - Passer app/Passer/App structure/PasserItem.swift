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
    func getItemName() -> String
}

final class PasswordItem: Identifiable, Codable, PasserItem {
    internal var id = UUID()
    private var itemname: String?
    private var group: Int?
    private var favourites: Bool?
    
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
    
    func getItemName() -> String {
        return self.itemname ?? "nil"
    }
}

final class BankCardItem: Identifiable, Codable, PasserItem  {
    internal var id = UUID()
    private var itemname: String?
    private var group: Int?
    private var favourites: Bool?
    
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
    
    func getItemName() -> String {
        return self.itemname ?? "nil"
    }
}

final class OtherItem: Identifiable, Codable, PasserItem {
    internal var id = UUID()
    private var itemname: String?
    private var group: Int?
    private var favourites: Bool?
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
    
    func getItemName() -> String {
        return self.itemname ?? "nil"
    }
}

