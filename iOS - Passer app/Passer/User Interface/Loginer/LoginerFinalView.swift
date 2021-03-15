//
//  LoginerFinalView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 15/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct LoginerFinalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var server: ServerDelegate
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                OptionSixdigit()
                    .contentShape(Rectangle())
            }
                .buttonStyle(PlainButtonStyle())
            .padding(.top, 60).padding(.bottom, 20)
            
            HStack {
                Text("Tap to exit").font(.footnote)
                Image(systemName: "arrow.up")
            }
            
            CodeCountdownView(server: server)
            
            if server.response != nil {
                Text("You can now log in!")
                    .multilineTextAlignment(.center)
                Button(action: {
                    //open website
                    let website = "https://google.com"
                    let url = URL(string: website)
                    UIApplication.shared.open(url!)
                }) {
                    Text("Open Browser")
                }
            }
            Spacer()
        }.padding(.bottom)
    }
}

struct LoginerFinalView_Previews: PreviewProvider {
    static var previews: some View {
        LoginerFinalView(server: ServerDelegate())
    }
}
