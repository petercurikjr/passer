//
//  Button.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI
import UIKit

struct ButtonUI: View {
    var name: String
    
    var body: some View {
        Text(self.name)
            .fontWeight(.bold)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("blue1"),Color("blue2")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(30)
        
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        ButtonUI(name: "Test")
            .previewLayout(.fixed(width: 150, height: 100))
    }
}
