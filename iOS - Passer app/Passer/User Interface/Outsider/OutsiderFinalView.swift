//
//  OutsiderFinalView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 15/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct OutsiderFinalView: View {
    
    @ObservedObject var server: ServerDelegate

    var body: some View {
        VStack {
            HStack {
                Text("Tap to go back").font(.footnote)
                Image(systemName: "arrow.up")
            }
            CodeCountdownView(server: server)
            Text("Visit the website below and enter")
            Text("this code to access selected items:")
                .multilineTextAlignment(.center)
            Button(action: {
                //open website
                let website = "https://passer.netlify.app"
                let url = URL(string: website)
                UIApplication.shared.open(url!)
            }) {
                Text("https://passer.netlify.app")
            }
            Spacer()
        }.padding(.bottom)
    }
}

struct OutsiderFinalView_Previews: PreviewProvider {
    static var previews: some View {
        OutsiderFinalView(server: ServerDelegate())
    }
}
