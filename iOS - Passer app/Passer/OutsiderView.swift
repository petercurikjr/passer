//
//  Outsider.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 08/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct OutsiderView: View {
    @State private var viewQRAlone = false
    @State private var viewDigitAlone = false
    @State private var oneOfThem = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var animationAmount: CGFloat = 1
    @State private var doAnimation = false
    
    @State private var sixdigitCode: String = ""
    @State private var timestamp: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .padding(.top, 20)
                        .padding(.trailing, 25)
                }
            }
    
             VStack {
                HStack {
                    Text("Outsider")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                }
                
                HStack {
                    Text("Tap on one of available options below to access your passwords on another device easily with Outsider.")
                        .font(.subheadline)
                    Spacer()
                }
             }.padding(30).multilineTextAlignment(.leading).padding(.top).opacity(oneOfThem ? 0 : 1).animation(Animation.easeInOut(duration: 1).delay(0.2))
            
            VStack {
                Button(action: {
                    self.triggerSixdigit()
                }) {
                    ZStack {
                        OptionSixdigit().opacity(viewQRAlone ? 0 : 1).animation(Animation.easeInOut(duration: 1))
                    }.scaleEffect(self.animationAmount)
                    .animation(Animation.timingCurve(1, -1.3, 0.32, 1.6))
                    .contentShape(Rectangle())
                
                }.offset(y: viewDigitAlone ? -120 : 0)
                .animation(Animation.easeInOut.delay(0.5))
                .buttonStyle(PlainButtonStyle())
                .padding()
                .disabled(viewQRAlone)
            
                ZStack {
                    CodeCountdownView(sixdigitCode: self.$sixdigitCode, initial: self.$timestamp)
                        .opacity(viewDigitAlone ? 1 : 0).animation(Animation.easeInOut(duration: 0.4).delay(viewDigitAlone ? 1 : 0))
                
                Button(action: {
                    self.triggerQR()
                }) {
                    ZStack {
                        OptionQR().opacity(viewDigitAlone ? 0 : 1).animation(Animation.easeInOut(duration: 1))
                    }.scaleEffect(self.animationAmount)
                    .animation(Animation.timingCurve(1, -1.3, 0.32, 1.6))
                    .contentShape(Rectangle())
                    
                }.offset(y: viewQRAlone ? -300 : 0)
                    .animation(Animation.easeInOut(duration: 0.5).delay(0.5))
                .buttonStyle(PlainButtonStyle())
                .padding()
                .disabled(viewDigitAlone)
                }
                
                Spacer()
        }
    }
}
    
    func triggerSixdigit() {
        self.viewDigitAlone.toggle()
        self.viewQRAlone = false
        
        self.changeButton()
        
        ///condition so that it doesn't generate a new code once user closes the verification code option
        if self.viewDigitAlone {
            
            let sixdigitstructure = generateStruct()
            
            self.sixdigitCode = sixdigitstructure.sixdigitCode
            self.timestamp = sixdigitstructure.timestamp
        }
    }
    
    func triggerQR() {
        self.viewQRAlone.toggle()
        self.viewDigitAlone = false
        
        self.changeButton()
    }
    
    func changeButton() {
        if self.viewDigitAlone || self.viewQRAlone {
            oneOfThem = true
        }
        else {
            oneOfThem = false
        }
        
        if self.animationAmount == 1 {
            self.animationAmount += 0.1
        }
        else {
            self.animationAmount -= 0.1
        }
    }
    
}

struct Outsider_Previews: PreviewProvider {
    static var previews: some View {
        OutsiderView()
    }
}
