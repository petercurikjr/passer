//
//  ContentView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var datatosend = JSONData(data: nil, timestamp: nil)

    var body: some View {
        VStack {
            Button(action: {
                self.datatosend = generateSixDigitCodeData()
                print(self.datatosend.data ?? "000000")
            }) {
            Text("Generate a sixdigit code")
            }
            
            Text("\n\nYour sixdigitcode: \(self.datatosend.data ?? "NaN")")
                .padding(30)
            
    
            Button(action: {
                guard let uploadData = try? JSONEncoder().encode(self.datatosend)
                    else {
                        return
                    }
                postToServer(uploadData: uploadData);
                
            }) {
            Text("Send")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
