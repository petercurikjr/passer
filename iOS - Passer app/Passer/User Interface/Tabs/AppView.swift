//
//  AppView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 21/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct AppView: View {
    
    ///Accessible by all child views. vault was created in SceneDelegate.swift when launching the app
    @EnvironmentObject var vault: Vault
    @EnvironmentObject var userSettings: UserSettings
    @State var authenticated = false
    
    ///Choose a default tab
    @State var selection: Int
    
    var body: some View {
        VStack {
            if 1==1/*authenticated*/ {
                TabView(selection: $selection) {
                    ItemsView(numberOfDisplayedItems: vault.passwordItems.count + vault.bankCardItems.count + vault.otherItems.count)
                        .tabItem {
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                            Text("Items")
                        }.tag(1)
                    
                    IdentityView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Identity")
                        }.tag(2)
                    
                    SettingsView(userSettings: userSettings)	
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }.tag(3)
                    

                }
            }
        }.onAppear(perform: {
            print("Testing phase. Authentication and cryptographic features turned off.")
            
            /*
            if self.vault.isEmpty() || !userSettings.useBiometry {
                self.authenticated = true
                
            }
            else {
                self.authenticateUser()
            }
            */
            
        })
    }
    
    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock passer", reply: { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.authenticated = true
                    }
                }
            })
        }
    }
    
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(selection: 1)
    }
}
