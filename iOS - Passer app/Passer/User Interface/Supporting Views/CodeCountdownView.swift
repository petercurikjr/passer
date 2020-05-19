//
//  CodeCountdownView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 10/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI
///UIKit provides spinner graphics
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    ///Spinner graphics. SwiftUI doesnt support it yet, so I need to wrap a UIKit loading spinner into a struct
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        // Start and stop UIActivityIndicatorView animation
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

struct CodeCountdownView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var diff: [String] = ["",""]
    @State var disabledButton = false
    @State private var spinner = true
    
    @ObservedObject var server = ServerDelegate()
    
    let chosenPasswords: [PasswordItem]
    let chosenBankCards: [BankCardItem]
    let chosenOthers: [OtherItem]
    
    var body: some View {
        VStack {
            if(self.server.approvedByServer != nil && self.server.serverDown == false) {
                HStack {
                    Text("Tap to go back").font(.footnote)
                    Image(systemName: "arrow.up")
                }
                HStack {
                    ///Here, im sure that sixdigitCode is not nil (thanks to the if statement), so I can confidently persuade Swift that the value contains something (by using "!")
                    Text((self.server.approvedByServer?.sixdigitCode)!.prefix(3))
                        .font(.system(size: 40))
                        .fontWeight(.thin)
                        .tracking(20)
                        .offset(x: 8, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.trailing, 2)
                    
                    ///Split the verification code to two Text elements for a esthetical gap between the two code halves
                    Text((server.approvedByServer?.sixdigitCode)!.suffix(3))
                        .font(.system(size: 40))
                        .fontWeight(.thin)
                        .tracking(20)
                        .offset(x: 8, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.leading, 2)
                    
                }.padding(.bottom, 30).padding(.top, 50)
                Text("Visit netlify.passer.app website")
                Text("and enter this code to access selected items.")
                Text("")
                    .multilineTextAlignment(.center)
                
                
                HStack {
                    Text("Time remaining: ")
                    Text(diff[0] + ":" + diff[1])
                        .foregroundColor(didItEnd(time: self.diff) ? Color.red : Color.primary)
                        .animation(nil)
                        .frame(width: 50)
                        .onReceive(timer) { _ in
                            self.diff = timeDelta(initial: (self.server.approvedByServer?.timestamp)!)
                            if didItEnd(time: self.diff) {
                                self.disabledButton = false
                            }
                    }
                }.padding(.top, 30)
                
                Button(action: {
                    ///Get new data from server
                    self.server.newSixdigitCode(passwordItems: self.chosenPasswords, bankCardItems: self.chosenBankCards, otherItems: self.chosenOthers)
                }) {
                    ButtonUI(name: "Generate a new code")
                }.padding()
                    .disabled(self.disabledButton)
                    .opacity(didItEnd(time: self.diff) ? 1 : 0)
                    .animation(Animation.easeInOut)
            }
                
            else {
                ///If the response is nil, this graphics show up
                ///If the device isn't even connected (Cellular off / Wifi off / Wifi on but no network / Wifi on but network not connected to the Internet) or if the server is dead, then this shows
                if (!connectedToInternet() || server.serverDown == true) {
                    VStack {
                        Text("We couldn't create a verification code for you. Make sure you are connected to the internet.")
                            .padding()
                        
                        Button(action: {
                            ///Get new data from server
                            self.server.newSixdigitCode(passwordItems: self.chosenPasswords, bankCardItems: self.chosenBankCards, otherItems: self.chosenOthers)
                            ///Restart timer
                            self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        }) {
                            ButtonUI(name: "Try again")
                        }
                    }.animation(Animation.easeInOut(duration: 0.2).delay(0))
                    
                }
                    
                else {
                    ///If the connection to the internet (WiFi / Cellular) is ok, we wait --> spinner shows up
                    ActivityIndicator(shouldAnimate: self.$spinner)
                }
            }
        }.padding().padding(.top,150)
            .onAppear(perform: {
                self.server.newSixdigitCode(passwordItems: self.chosenPasswords, bankCardItems: self.chosenBankCards, otherItems: self.chosenOthers)
            })
        
    }
}

struct CodeCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        ///.constant deals with creating Binding property variables in preview
        CodeCountdownView(chosenPasswords: [PasswordItem](), chosenBankCards: [BankCardItem](), chosenOthers: [OtherItem]())
    }
}
