//
//  TestView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 03/05/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//


///This view is only for testing purposes

import SwiftUI

struct TestView: View {
    
    @State var spinac = false
    
    var body: some View {
        VStack {
        Form {
            Button(action: {
                self.spinac.toggle()
            }) {
            ButtonUI(name: "Test")
                
            }.buttonStyle(BorderlessButtonStyle())
            
        }
            List {
                Text("Item")
                VStack {
                    Text("Velky text")
                        .bold()
                        .padding(34)
                        .font(.largeTitle)
                        .foregroundColor(Color.green)
                        
                    
                    Button(action: {
                        self.spinac.toggle()
                    }) {
                        Text("Button")
                    }.buttonStyle(DefaultButtonStyle())
                }
            }
            Button(action: {
                self.spinac.toggle()
            }) {
                ButtonUI(name: "Another one")
            }
            
        }
        .sheet(isPresented: $spinac, content: {
            Text("yaay")
        })
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
