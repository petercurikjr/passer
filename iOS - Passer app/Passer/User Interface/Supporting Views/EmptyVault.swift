//
//  EmptyVault.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 28/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct EmptyVault: View {
    
    @State var showAddPassword = false
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        VStack {
            Text("Empty room here!")
                .font(.headline)
            Text("Why don't you add some items?")
            Image(systemName: "arrowtriangle.down.circle.fill")
            Button(action: {
                self.showAddPassword = true
            }) {
                ButtonUI(name: "Add a new Passer item")
            }.padding(20)
            .sheet(isPresented: self.$showAddPassword) {
                AddPasswordView().environmentObject(self.vault)
            }
        }
    }
}

struct EmptyVault_Previews: PreviewProvider {
    static var previews: some View {
        EmptyVault()
    }
}
