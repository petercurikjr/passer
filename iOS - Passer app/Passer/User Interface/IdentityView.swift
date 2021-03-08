//
//  IdentityView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct IdentityView: View {
    @State private var showAddIdentity = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Passer Identity")
                    .bold()
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    self.showAddIdentity = true
                }) {
                    Image(systemName: "plus")
                }
                    .sheet(isPresented: self.$showAddIdentity) {
                        AddPasserIdentityView()
                }
            }
        }.padding(.horizontal, 30).multilineTextAlignment(.leading).padding(.vertical).padding(.top)
    }
}

struct IdentityView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityView()
    }
}
