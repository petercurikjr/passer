
//
//  OptionSixdigit.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 09/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct OptionSixdigit: View {

    var body: some View {
        
       ZStack {
               Rectangle()
                   .fill(LinearGradient(
                       gradient: Gradient(colors: [Color("blue1"),Color("blue2")]), startPoint: .top, endPoint: .bottomTrailing))
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
           }.contentShape(Rectangle())
    }
}

struct OptionSixdigit_Previews: PreviewProvider {
    static var previews: some View {
        OptionSixdigit()
           .previewLayout(.fixed(width: 400, height: 200))
    }
}
