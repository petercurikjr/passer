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
    @State private var showModal = false
    
    var body: some View {
        Button(action: {
                self.showModal = true
            }) {
                ButtonUI(name: "Outsider")
           
        ///sheet determines whether modalview should be displayed
        ///(here's when showModal comes handy)
        }
        .sheet(isPresented: self.$showModal) {
            OutsiderView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
