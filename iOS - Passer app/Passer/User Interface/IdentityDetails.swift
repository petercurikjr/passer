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
    @State private var showClaimsChooser = false
    
    var body: some View {
        VStack {
            Text("Identity Details")
                .bold()
                .font(.largeTitle)
            
            Text(chosenIdentity.firstName ?? "NaN")
            Text(chosenIdentity.lastName ?? "NaN")
            Text(chosenIdentity.email ?? "Not provided")
            Text(chosenIdentity.gender?.rawValue ?? Gender.unspecified.rawValue)
            Text(chosenIdentity.convertDate(date: chosenIdentity.birthDate, mode: .dotted))
            
            Button(action: {
                self.showClaimsChooser = true
            }) {
                ButtonUI(name: "Loginer")
            }
        }.opacity(showClaimsChooser ? 0 : 1).animation(Animation.easeInOut(duration: 0.7))
        
        IdentityClaimsChooserView(chosenIdentity: chosenIdentity)
            .opacity(showClaimsChooser ? 1 : 0).animation(Animation.easeInOut(duration: 0.7))
    }
}

struct IdentityDetails_Previews: PreviewProvider {
    static var previews: some View {
        IdentityDetails(chosenIdentity: Identity(firstName: "", lastName: "", email: "", phoneNumber: "", birthDate: Date(), username: "", gender: Gender.male, address: Address(country: nil, formatted: nil, locality: nil, postal_code: nil, region: nil, street_address: nil)))
    }
}
