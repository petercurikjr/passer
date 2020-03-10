//
//  ContentView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var password: String = ""
    @State var passwordItem = PasswordItem()

    var body: some View {
        VStack {
            Text("Your password:")
                .padding()
            TextField("password:", text: $password)
                .frame(width: 300, height: 30)
                .border(Color.blue, width: 1)
            Button(action: {
                self.passwordItem.passw = self.password
            }) {
            Text("Save")
            }
            Text("\n\npasswordItem: \(passwordItem.passw)\n password: \(password)")
                .padding(30)
            
            Button(action: {
                self.passwordItem.passw = self.password
            }) {
            Text("Transfer to website")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
