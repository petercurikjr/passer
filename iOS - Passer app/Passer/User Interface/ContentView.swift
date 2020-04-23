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
    ///access it later using $ sign
    @State private var showOutsider = false
    @State private var showAddPassword = false
    
    ///Have to create this only because of .sheet bug not acting like a child to this view
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        VStack {
            Button(action: {
                    self.showOutsider = true
                }) {
                    ButtonUI(name: "Outsider")
                    
            ///sheet determines whether modalview should be displayed
            }
            .sheet(isPresented: self.$showOutsider) {
                OutsiderView()
            }
            
            Button(action: {
                    self.showAddPassword = true
                }) {
                    Image(systemName: "plus")
            }
                
            ///Sheets are supposed to be understood as children to a view which creates them. But it does not work for now, Apple promised a fix for this. Until then, we have to pass the EnvironmentObject by hand as a parameter to a view under .sheet
            ///If sheets acted normally, we would not have to create EnvironmentObject in ContentView, since it is already in AppView.
            .sheet(isPresented: self.$showAddPassword) {
                AddPasswordView().environmentObject(self.vault)
            }
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
