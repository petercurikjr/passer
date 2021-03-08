//
//  IdentityDetails.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 08/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct IdentityDetails: View {
    let chosenIdentity: Identity
    @State private var showLoginer = false
    
    var body: some View {
        VStack {
            Text("Identity Details")
                .bold()
                .font(.largeTitle)
            
            Text(chosenIdentity.firstName)
            Text(chosenIdentity.lastName)
            Text(chosenIdentity.email ?? "Not provided")
            Text(chosenIdentity.gender?.rawValue ?? Gender.unspecified.rawValue)
            Text(chosenIdentity.convertDate(date: chosenIdentity.birthDate, mode: .dotted))
            Text(chosenIdentity.convertDate(date: chosenIdentity.birthDate, mode: .dashed))
            
            Button(action: {
                self.showLoginer = true
            }) {
                ButtonUI(name: "Loginer")
            }
        }
    }
}

struct IdentityDetails_Previews: PreviewProvider {
    static var previews: some View {
        IdentityDetails(chosenIdentity: Identity(firstName: "bla", lastName: "bla", email: "bla", birthDate: Date(), username: "", gender: .male, address: Address(country: "", formatted: "", locality: "", postal_code: "", region: "", street_address: "")))
    }
}
