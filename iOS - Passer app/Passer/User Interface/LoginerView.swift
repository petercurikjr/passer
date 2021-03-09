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
    let chosenAttributes: [Int]
    @ObservedObject var serverDelegate = ServerDelegate()
    
    var body: some View {
        VStack {
            Text("Loginer")
        }
        .onAppear(perform: {
            let jsonToSend = identityToJSON(identity: generatePasserIdentityStruct(identity: chosenIdentity, selectedItems: chosenAttributes))
            self.serverDelegate.postToServer(jsonToUpload: jsonToSend!)
            
        })
    }
}

struct LoginerView_Previews: PreviewProvider {
    static var previews: some View {
        LoginerView(
            chosenIdentity: Identity(firstName: "", lastName: "", email: "", phoneNumber: "", birthDate: Date(), username: "", gender: Gender.male, address: Address(country: nil, formatted: nil, locality: nil, postal_code: nil, region: nil, street_address: nil)),
            chosenAttributes: [Int]())
    }
}
