//
//  Password.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import CryptoKit

class PasswordItem: Codable {
    private var itemname: String
    private var username: String?
    private var password: String
    private var url: String?
    var favourite: Bool = false
    
    init(itemname: String, username: String?, password: String, url: String?) {
        self.itemname = itemname
        self.username = username
        self.password = password
        self.url = url
    }
    
    func getItemName() -> String {
        return self.itemname
    }
}

