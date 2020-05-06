//
//  OptionQR.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 09/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct OptionQR: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color("blue1"),Color("blue2")]), startPoint: .leading, endPoint: .bottomTrailing))
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
    }
}

struct OptionQR_Previews: PreviewProvider {
    static var previews: some View {
        OptionQR()
            .previewLayout(.fixed(width: 400, height: 200))

    }
}
