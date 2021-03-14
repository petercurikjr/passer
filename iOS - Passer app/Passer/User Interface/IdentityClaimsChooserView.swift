//
//  IdentityClaimsChooserView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 08/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct IdentityClaimsChooserView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let chosenIdentity: Identity
    @State private var chosenAttributes = [Int]()
    
    @Binding var goBack: Bool
    
    @State private var showLoginer = false
    @State var checkedAll = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        self.goBack.toggle()
                    }) {
                        Image(systemName: "arrow.left")
                            .padding(.top, 20)
                            .padding(.leading, 25)
                    }
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
                        Text("Loginer")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Your assistant with logging in.")
                            .font(.subheadline)
                        Spacer()
                    }
                }.padding(30).multilineTextAlignment(.leading)
                
                Text("Which of these credentials should we provide the 3rd party app you are trying to get to?")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40).padding()
                
                List {
                    
                    Button(action: {
                        self.checkedAll.toggle()
                        self.selectDeselectAll()
                    }) {
                        HStack {
                            Image(systemName: self.checkedAll ? "checkmark.square": "square")
                            Text(self.checkedAll ? "Deselect all" : "Select all")
                                .animation(Animation.easeIn(duration: 0.5))
                        }
                    }
                    
                    Section(header: Text("Your credentials")) {
                        ForEach(0..<self.chosenIdentity.attrKeys.count) { index in
                            Button(action: {
                                self.selectDeselect(number: index)
                            }) {
                                HStack {
                                    Image(systemName: self.chosenAttributes.contains(index) ? "checkmark.square": "square")
                                    Text(self.chosenIdentity.attrKeys[index])
                                }
                            }
                        }
                    }
                    
                }.listStyle(GroupedListStyle())
                
                VStack {
                    Button(action: {
                        self.showLoginer.toggle()
                    }) {
                        ButtonUI(name: "Proceed")
                    }
                }
                Spacer()
            }.opacity(showLoginer ? 0 : 1).animation(Animation.easeInOut(duration: 0.7))
            
            if self.showLoginer {
                LoginerView(chosenIdentity: chosenIdentity, chosenAttributes: chosenAttributes)
                    .opacity(showLoginer ? 1 : 0).animation(Animation.easeInOut(duration: 0.7))
            }
            
        }
    }
    
    private func selectDeselect(number: Int) {
        if(self.chosenAttributes.contains(number)) {
            self.chosenAttributes.remove(at: self.chosenAttributes.firstIndex(of: number)!)
        }
        
        else {
            self.chosenAttributes.append(number)
        }
    }
    
    private func selectDeselectAll() {
        self.chosenAttributes.removeAll()
        
        if self.checkedAll {
            self.chosenAttributes.append(contentsOf: Array(0...self.chosenIdentity.attrKeys.count))
        }
    }
}

struct IdentityClaimsChooserView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityClaimsChooserView(chosenIdentity: Identity(firstName: "", lastName: "", email: "", phoneNumber: "", birthDate: Date(), username: "", gender: Gender.male, address: Address(country: nil, formatted: nil, locality: nil, postal_code: nil, region: nil, street_address: nil)), goBack: .constant(false))
    }
}
