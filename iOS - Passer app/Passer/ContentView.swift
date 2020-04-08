//
//  ContentView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var datatosend = JSONData(sixdigitCode: nil, deviceID: nil)

    var body: some View {
        
        
        VStack {
            VStack {
                Text("Outsider")
                    .bold()
                    .font(.largeTitle)
                Text("Access your passwords on another device easily.")
                    .font(.subheadline)
                    .offset(x: 0, y: -5)
                    
            }.padding(.top, 100)
            //.animation(.easeIn)

            VStack {
                Text("Choose a verification method to proceed:")
                    .padding(.top, 80)
                
                Button(action: {
                   self.datatosend = generateSixDigitCodeData()
                    guard let uploadData = try? JSONEncoder().encode(self.datatosend)
                        else {
                            return
                        }
                    postToServer(uploadData: uploadData);
                   print("Generated: " + (self.datatosend.sixdigitCode ?? "000000"))
                }) {
                    ButtonUI(name: "Generate a sixdigit code")
                    .padding()
                }
                
                
                Button(action: {
                   self.datatosend = generateSixDigitCodeData()
                   print("Generated: " + (self.datatosend.sixdigitCode ?? "000000"))
                }) {
                    ButtonUI(name: "Generate a QR code")
                    .padding()
                }
                Spacer()
            
            }

        
        }
        
       

        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
