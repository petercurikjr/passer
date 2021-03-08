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
            Text("Passer Items")
                .bold()
                .font(.largeTitle)
            Text("Your passwords and other valuable data:")
                .multilineTextAlignment(.center)
            Text("all at one place.")
        }.padding().padding(.vertical)

        Image(systemName: "pencil.and.ellipsis.rectangle")
            .font(.system(size: 90))
        
        Text("Adding these items is simple: just click the button below to start!")
            .multilineTextAlignment(.center)
            .padding()
        
        
        Button(action: {
            self.showAddPassword = true
        }) {
            ButtonUI(name: "Add a new Passer Item")
        }
            .sheet(isPresented: self.$showAddPassword) {
                AddPasserItemView()
        }.padding()
    }
}

struct EmptyVault_Previews: PreviewProvider {
    static var previews: some View {
        EmptyVault()
    }
}
