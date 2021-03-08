//
//  LoginerView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 08/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct LoginerView: View {
    
    let chosenIdentity: Identity
    
    var body: some View {
        Text("Loginer")
    }
}

struct LoginerView_Previews: PreviewProvider {
    static var previews: some View {
        LoginerView(chosenIdentity: Identity(firstName: "bla", lastName: "bla", email: "bla", birthDate: Date(), username: "", gender: .male, address: Address(country: "", formatted: "", locality: "", postal_code: "", region: "", street_address: "")))
    }
}
