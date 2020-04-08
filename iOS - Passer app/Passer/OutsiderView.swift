//
//  Outsider.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 08/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct OutsiderView: View {
    @State var datatosend = JSONData(sixdigitCode: nil, deviceID: nil)
    @State private var doAnimation = false
    @State private var sixDigitDisabled = true
    @State private var qrDisabled = true
    @State private var animationAmount: CGFloat = 1
    @Environment(\.presentationMode) var presentationMode
    
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
                        .offset(y: -5)
                    Spacer()
                }
             }.padding(30).multilineTextAlignment(.leading).padding(.top)
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color("buttoncolor2"),Color("buttoncolor1")]), startPoint: .top, endPoint: .bottomTrailing))
                    .frame(width: 300, height: 150)
                    .cornerRadius(20)
                    .opacity(1)
                    .shadow(radius: 15)
                
                Image("sixdigit-ios")
                    .frame(width: 300, height: 150)
                    .clipped()
                    .cornerRadius(20)
                
                VStack {
                    Text("Verification code")
                        .font(.title)
                        .fontWeight(.medium)
                    Text("Use a temporary, six-digit code to verify yourself on a device without Passer.")
                        .frame(width: 280, height: 70)
                        .font(.callout)
                }
            }.padding()
                .scaleEffect(animationAmount)
                .animation(Animation.timingCurve(1, -1.3, 0.32, 1.6))

            .contentShape(Rectangle())
            .onTapGesture {
                //trigger animation
                if(self.sixDigitDisabled) {
                    self.sixDigitDisabled.toggle()
                    self.doAnimation.toggle()
                    self.animationAmount += 0.1
                    self.datatosend = generateSixDigitCodeData()
                     guard let uploadData = try? JSONEncoder().encode(self.datatosend)
                         else {
                             return
                         }
                     postToServer(uploadData: uploadData);
                    print("Generated: " + (self.datatosend.sixdigitCode ?? "000000"))
                }
 
            }
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color("buttoncolor1"),Color("buttoncolor2")]), startPoint: .leading, endPoint: .bottomTrailing))
                    .frame(width: 300, height: 150)
                    .cornerRadius(20)
                    .opacity(1)
                    .shadow(radius: 15)
                    
                Image("qr-ios")
                    .frame(width: 300, height: 150)
                    .clipped()
                    .cornerRadius(20)

                VStack {
                    Text("QR code")
                        .fontWeight(.medium)
                        .font(.title)
                    Text("Scan a QR code to verify yourself on a device without Passer.")
                        .frame(width: 280, height: 70)
                        .font(.callout)
                }
            }.contentShape(Rectangle())
            Spacer()
        }
    }
}

struct Outsider_Previews: PreviewProvider {
    static var previews: some View {
        OutsiderView()
    }
}
