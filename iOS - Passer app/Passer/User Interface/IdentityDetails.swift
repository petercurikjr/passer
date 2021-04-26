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
        ZStack {
            VStack {
                HStack {
                    Text("Identity Details")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                }.padding(.top, 40).padding(.horizontal, 25)
                
                List {
                    HStack {
                        if chosenIdentity.firstName != nil {
                            Text(chosenIdentity.firstName!)
                                .bold()
                                .font(.headline)
                        }
                        
                        if chosenIdentity.middleName != nil {
                            Text(chosenIdentity.middleName!)
                                .bold()
                                .font(.headline)
                        }
                        
                        if chosenIdentity.lastName != nil {
                            Text(chosenIdentity.lastName!)
                                .bold()
                                .font(.headline)
                        }
                    }
                
                    Section(header: Text("Basic information")) {
//                        ForEach(1..<self.chosenIdentity.basicInformationCategory.count) { index in
//                            Text(self.chosenIdentity.basicInformationCategory[index][0]!)
//                                .bold()
//                                .font(.headline)
//                        }
                        if chosenIdentity.username != nil {
                            HStack {
                                Text("Username:")
                                Spacer()
                                Text(chosenIdentity.username!)
                                    .padding(.trailing)
                            }
                        }
                        
                        HStack {
                            Text("Gender:")
                            Spacer()
                            Text(chosenIdentity.gender?.rawValue ?? Gender.unspecified.rawValue)
                                .padding(.trailing)
                        }
                        
                        if chosenIdentity.birthDate != nil {
                            HStack {
                                Text("Birth date:")
                                Spacer()
                                Text(chosenIdentity.convertDate(date: chosenIdentity.birthDate, mode: .dotted))
                                    .padding(.trailing)
                            }
                        }
                    }
                    
                    Section(header: Text("Contact")) {
                        HStack {
                            Text("Mail:")
                            Spacer()
                            Text(chosenIdentity.email ?? "")
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Phone:")
                            Spacer()
                            Text(chosenIdentity.phoneNumber ?? "")
                                .padding(.trailing)
                        }
                    }
                    
                    Section(header: Text("Address")) {
                        HStack {
                            Text("Street:")
                            Spacer()
                            Text(chosenIdentity.address?.street_address ?? "")
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Postal Code:")
                            Spacer()
                            Text(chosenIdentity.address?.postal_code ?? "")
                                .padding(.trailing)
                        }
                        HStack {
                            Text("City:")
                            Spacer()
                            Text(chosenIdentity.address?.locality ?? "")
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Region:")
                            Spacer()
                            Text(chosenIdentity.address?.region ?? "")
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Country:")
                            Spacer()
                            Text(chosenIdentity.address?.country ?? "")
                                .padding(.trailing)
                        }
                    }
                    
                    Section(header: Text("Other")) {
                        HStack {
                            Text("Nickname:")
                            Spacer()
                            Text(chosenIdentity.nickname ?? "")
                                .padding(.trailing)
                        }
                    }
 
                }.listStyle(InsetGroupedListStyle())
                
                Button(action: {
                    self.showClaimsChooser.toggle()
                }) {
                    ButtonUI(name: "Loginer")
                }.padding(3)
            }.opacity(showClaimsChooser ? 0 : 1).animation(Animation.easeInOut(duration: 0.7))
        
            IdentityClaimsChooserView(chosenIdentity: chosenIdentity, goBack: self.$showClaimsChooser)
                .opacity(showClaimsChooser ? 1 : 0).animation(Animation.easeInOut(duration: 0.7))
        }
    }
}

struct IdentityDetails_Previews: PreviewProvider {
    static var previews: some View {
        IdentityDetails(chosenIdentity: Identity(firstName: "", lastName: "", middleName: "", email: "", phoneNumber: "", birthDate: Date(), username: "", nickname: "", gender: Gender.male, address: Address(country: nil, formatted: nil, locality: nil, postal_code: nil, region: nil, street_address: nil)))
    }
}
