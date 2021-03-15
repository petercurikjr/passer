//
//  SettingsView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 21/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()
    @State private var alert = false
    @EnvironmentObject var vault: Vault
    
    @State private var supportedBiometry: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("")) {
                    Picker(selection: $userSettings.tab, label: Text("Default Tab")) {
                        ForEach(userSettings.tabs, id: \.self) { tab in
                            Text(tab)
                        }
                    }
                    
                    if supportedBiometry != nil {
                        Toggle("Use \(supportedBiometry!)", isOn: $userSettings.useBiometry)
                    }
                }
                
                Section {
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
            .navigationBarTitle("Settings")
        }.onAppear {
            self.setSupportedBiometry()
        }
    }
    
    private func setSupportedBiometry() {
        let context = LAContext()
        
        if context.biometryType == .faceID {
            self.supportedBiometry = "Face ID"
        }
        
        else if context.biometryType == .touchID {
            self.supportedBiometry = "Touch ID"
        }
        
        else {
            self.supportedBiometry = nil
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userSettings: UserSettings())
    }
}
