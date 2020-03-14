//
//  main.swift
//  test
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import CryptoKit
import Network

//class Passwords
struct Passwords {
    var testval: Int = 0
    var anotherval: String = ""
}

//testing behaviour of an Password instance
var manen = Passwords(testval: 3, anotherval: "ll")

//testing hashing and joining string array into one string
var sixdigitCode = ["1","2","3","4","5","6"]
var codeJoined = sixdigitCode.joined()
var codeFormatted = Data(codeJoined.utf8)
var codeHashed = SHA256.hash(data: codeFormatted)
print(codeHashed)

var sixdigitCode2 = ["1","2","3","4","5","6"]
var codeJoined2 = sixdigitCode2.joined()
var codeFormatted2 = Data(codeJoined2.utf8)
var codeHashed2 = SHA256.hash(data: codeFormatted2)
print(codeHashed2)

print(codeHashed == codeHashed2)
