//
//  CodeCountdownView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 10/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct CodeCountdownView: View {
    ///Binding allows child view (this one) to control parent view (OutsiderView.swift)
    ///we need this when the code expires and we want a new one
    @Binding var sixdigitCode: String
    @Binding var initial: Date
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var diff: [String] = ["",""]
    @State var disabledButton: Bool = false
    
    var body: some View {
        VStack {
        VStack {
            ///Split the verification code to two Text elements for a esthetical gap between the two code halves
            HStack {
                Text(self.sixdigitCode.prefix(3))
                    .font(.system(size: 40))
                    .fontWeight(.thin)
                    .tracking(20)
                    .offset(x: 8, y: -50)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 2)
                
                Text(self.sixdigitCode.suffix(3))
                .font(.system(size: 40))
                .fontWeight(.thin)
                .tracking(20)
                .offset(x: 8, y: -50)
                .multilineTextAlignment(.center)
                .padding(.leading, 2)
                
            }.padding(.bottom, 30)
            Text("This is your six-digit verification code.")
            Text("Visit pass.me and enter it to access your passwords.")
                .multilineTextAlignment(.center)
                .frame(width: 300, height: 60)
            
            HStack {
                Text("Time remaining: ")
                Text(diff[0] + ":" + diff[1])
                    .foregroundColor(didItEnd(time: self.diff) ? Color("rectCol1") : Color.primary)
                    .animation(nil)
                    .frame(width: 50)
                    .onReceive(timer) { input in
                        self.diff = timeDelta(initial: self.initial)
                        //self.now = input
                        if didItEnd(time: self.diff) {
                            self.disabledButton = false
                        }
                    }
            }.padding(.top, 30)
            
            Button(action: {
                self.disabledButton.toggle()
                let sixdigitstructure = generateStruct()
                
                self.sixdigitCode = sixdigitstructure.sixdigitCode
                self.initial = sixdigitstructure.timestamp
               }) {
                   ButtonUI(name: "Generate a new code")
               }.padding()
                .disabled(self.disabledButton)
                //.buttonStyle(PlainButtonStyle())
                .opacity(didItEnd(time: self.diff) ? 1 : 0)
                .animation(Animation.easeInOut)
            }
        }
    }
}

struct CodeCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        ///.constant deals with creating Binding property variables in preview
        CodeCountdownView(sixdigitCode: .constant("123456"), initial: .constant(Date()))
    }
}
