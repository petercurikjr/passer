//
//  SettingsView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 21/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var alert = false
    @EnvironmentObject var vault: Vault

    var body: some View {
        Button(action: {
            self.alert = true
        }){
            Text("Erase all Passer data").foregroundColor(Color.red)
        }
        .alert(isPresented: self.$alert){
             Alert(title: Text("Are you sure?"), primaryButton: Alert.Button.default(Text("Yes"), action: {
                self.vault.vaultErase()
             }), secondaryButton: Alert.Button.cancel(Text("No"), action: {
                 print("no clicked")
             }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
