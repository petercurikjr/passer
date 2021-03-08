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
    
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        if 1==2/*!self.vault.identities.isEmpty*/ {
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
