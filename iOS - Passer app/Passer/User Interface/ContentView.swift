//
//  ContentView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    ///State means "variable can update the view (locally)"
    @State private var showOutsider = false
    @State private var showAddPassword = false
    
    ///Have to create this only because of .sheet bug not acting like a child to this view
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        
        VStack {
            if(self.vault.isEmpty()) {
                EmptyVault()
            }
                
            else {
                VStack {
                    HStack {
                        Text("Your secrets")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                        Button(action: {
                            self.showAddPassword = true
                        }) {
                            Image(systemName: "plus")
                        }
                            ///Sheets are supposed to be understood as children to a view which creates them. But it does not work for now, Apple promised a fix for this. Until then, we have to pass the EnvironmentObject by hand as a parameter to a view
                            ///Otherwise, we would not have to create EnvironmentObject in ContentView, since it is already in AppView.
                            .sheet(isPresented: self.$showAddPassword) {
                                AddPasswordView().environmentObject(self.vault)
                        }
                    }
                    
                    HStack {
                        Text("Manage and view your passwords, credit card items, and more.")
                            .font(.subheadline)
                        Spacer()
                    }
                }.padding(30).multilineTextAlignment(.leading).padding(.top)
                
                List {
                    Section(header: Text("Password items")) {
                        ForEach(self.vault.passwordItems) { item in
                            Text(item.getItemName())
                        }.onDelete { indexSet in
                            self.vault.passwordItems.remove(atOffsets: indexSet)
                            self.vault.vaultUpdate(vault: self.vault)
                        }
                    }
                    Section(header: Text("Bank card items")) {
                        ForEach(self.vault.bankCardItems) { item in
                            Text(item.getItemName())
                        }.onDelete { indexSet in
                            self.vault.bankCardItems.remove(atOffsets: indexSet)
                            self.vault.vaultUpdate(vault: self.vault)
                        }
                    }
                    Section(header: Text("Other items")) {
                        ForEach(self.vault.otherItems) { item in
                            Text(item.getItemName())
                        }.onDelete { indexSet in
                            self.vault.otherItems.remove(atOffsets: indexSet)
                            self.vault.vaultUpdate(vault: self.vault)
                        }
                    }
                }.onAppear { UITableView.appearance().separatorStyle = .singleLine }
                
                Button(action: {
                    self.showOutsider = true
                }) {
                    ButtonUI(name: "Outsider")
                    
                    ///sheet determines whether modalview should be displayed
                }.padding()
                    .sheet(isPresented: self.$showOutsider) {
                        OutsiderView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
