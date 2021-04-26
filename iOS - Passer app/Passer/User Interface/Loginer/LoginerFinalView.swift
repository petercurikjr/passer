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
    @ObservedObject var socket: Socket
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Button(action: {
                socket.logout()
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
            
            if socket.sixDigitCode != nil {
                HStack {
                    ///Here, im sure that sixdigitCode is not nil (thanks to the if statement), so I can confidently persuade Swift that the value contains something (by using "!")
                    Text((socket.sixDigitCode)!.prefix(3))
                        .font(.system(size: 40))
                        .fontWeight(.thin)
                        .tracking(20)
                        .offset(x: 8, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.trailing, 2)
                    
                    ///Split the verification code to two Text elements for a esthetical gap between the two code halves
                    Text((socket.sixDigitCode)!.suffix(3))
                        .font(.system(size: 40))
                        .fontWeight(.thin)
                        .tracking(20)
                        .offset(x: 8, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.leading, 2)
                    
                }.padding(.top, 25)
                
                Spacer()
                
                Text("You can now log in to all supported websites!")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Button(action: {
                    //open website
                    let website = "https://tp-ai-login.netlify.app"
                    let url = URL(string: website)
                    UIApplication.shared.open(url!)
                }) {
                    Text("Open Browser")
                }
                
                Spacer()
                
                Text("Finished? Log out to destroy this temporary code.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Button(action: {
                    socket.logout()
                }) {
                    ButtonUI(name: "Log out")
                }
            }
            
            else {
                Spacer()
                Button(action: {
                    socket.login()
                }) {
                    ButtonUI(name: "Login")
                }.padding()
                
                Spacer()
            }
            
            Spacer()
        }.padding(.bottom)
    }
}

//struct LoginerFinalView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginerFinalView(socket: Socket())
//    }
//}
