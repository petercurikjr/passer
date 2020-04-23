//
//  AppView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 21/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    ///Accessible by all child views. vault was created in SceneDelegate.swift when launching the app
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        TabView() {
            ContentView()
                .tabItem {
                    Image(systemName: "pencil.and.ellipsis.rectangle")
                    Text("Passwords")
                }.tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(2)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
