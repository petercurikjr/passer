//
//  IdentityView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct IdentityView: View {
    @State private var showAddIdentity = false
    @State private var showIdentityDetails = false
    
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        if !self.vault.identities.isEmpty {
            VStack {
                HStack {
                    Text("Passer Identity")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                    Button(action: {
                        self.showAddIdentity = true
                    }) {
                        Image(systemName: "plus")
                    }
                        .sheet(isPresented: self.$showAddIdentity) {
                            AddPasserIdentityView()
                    }
                }.padding()
                
                VStack {
                    List(self.vault.identities) { identity in
                        HStack {
                            Text(identity.firstName + " " + identity.lastName)
                            Spacer()
                            Button(action: {
                                self.showIdentityDetails = true
                            }) {
                                Image(systemName: "person.fill")
                            }
                            .sheet(isPresented: self.$showIdentityDetails) {
                                IdentityDetails(chosenIdentity: identity)
                            }
                        }.contentShape(Rectangle()).padding(2)
                    }
                }
            }.padding(.horizontal, 30).multilineTextAlignment(.leading).padding(.vertical).padding(.top)
        }
        
        else {
            VStack {
                VStack {
                    Text("Passer Identity")
                        .bold()
                        .font(.largeTitle)
                    Text("An identity which belongs only to you.")
                }.padding().padding(.vertical)

                Image(systemName: "person.fill")
                    .font(.system(size: 100))
                
                Text("Create one now to access various apps and services with only one account - your Passer Identity.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    self.showAddIdentity = true
                }) {
                    ButtonUI(name: "Create a Passer Identity")
                }
                    .sheet(isPresented: self.$showAddIdentity) {
                        AddPasserIdentityView()
                }.padding()
            }
        }
    }
}

struct IdentityView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityView()
    }
}
