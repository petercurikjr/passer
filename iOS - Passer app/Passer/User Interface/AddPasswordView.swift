//
//  AddPasswordView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 21/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct AddPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vault: Vault
    
    @State private var itemname: String = ""    ///Mandatory
    @State private var username: String = ""
    @State private var password: String = ""    ///Mandatory
    @State private var url: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .padding(.top, 20)
                        .padding(.trailing, 25)
                }
            }
            VStack {
                HStack {
                    Text("New Passer item")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                }

                HStack {
                    Text("You can add your secrets here. Passer encrypts and can't read your data. ")
                        .font(.subheadline)
                    Spacer()
                }
            }.padding(30).multilineTextAlignment(.leading).padding(.top)
            
            Form {
                Section {
                    TextField("Item name", text: $itemname)
                    TextField("Username", text: $username)
                    TextField("Password", text: $password)
                    TextField("Website", text: $url)
                }
            }
        
            Spacer()
            
            Button(action: {
                if self.password == "" || self.itemname == "" {
                    //Text("Error")
                }
                else {
                    let newItem = PasswordItem(itemname: self.itemname, username: self.username, password: self.password, url: self.url)
                    self.vault.vaultPush(item: newItem, vault: self.vault)
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                ButtonUI(name: "Add to Passer")
            }.padding()
        }
    }
}

struct AddPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        AddPasswordView()
    }
}
