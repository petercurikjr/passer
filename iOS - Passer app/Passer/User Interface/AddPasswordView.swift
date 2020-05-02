//
//  AddPasswordView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 21/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct AddPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vault: Vault
    
    ///PasserItem
    @State private var itemname: String = ""    ///Mandatory
    @State private var group: Int = 0
    @State private var favourites = false
    
    ///PasswordItem
    @State private var username: String = ""
    @State private var password: String = ""    ///Mandatory
    @State private var url: String = ""
    
    ///BankCardItem
    @State private var cardNumber: String = ""  ///Mandatory
    @State private var expireDate: String = ""  ///Mandatory
    @State private var cvv: String = ""         ///Mandatory
    @State private var pinNumber: String = ""
    
    ///OtherItem
    @State private var field1: String = ""
    @State private var field2: String = ""
    @State private var field3: String = ""
    @State private var field4: String = ""
    
    ///Booleans
    @State private var toggleIsOn: Bool = false
    @State private var hideGroups = true
    @State private var buttonDisabled = true
    
    @State private var itemType: Int = 0
    
    init() {
        UITableView.appearance().separatorColor = .clear
    }
    
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
                    Text("New Passer item")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                }

                HStack {
                    Text("You can add your secrets here. Passer encrypts and can't read your data. ")
                        .font(.subheadline)
                    Spacer()
                }
            }.padding(30).multilineTextAlignment(.leading).padding(.top)
            
            Form {
                Section(header: Text("This field is required.")) {
                    Text("Name your Passer item:")
                        .font(.body)
                        .offset(x: 0, y: 7)
                        
                    TextField("", text: $itemname, onEditingChanged: { _ in
                        ///Item name can't be empty nor contain only spaces
                        while(self.itemname.hasSuffix(" ")) {
                            self.itemname.removeLast()
                        }
                        if !self.password.isEmpty && !self.itemname.isEmpty {
                            self.buttonDisabled = false
                        }
                        else {
                            self.buttonDisabled = true
                        }
                    })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section {
                    Text("What would you like to add?")
                    
                    Picker(selection: $itemType, label: Text("")) {
                        Text("A password")
                            .tag(1)
                        Text("A bank card")
                            .tag(2)
                        Text("Other")
                            .tag(3)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                if self.itemType == 1 {
                    Section(header: Text("Field 'Password' is mandatory.")) {
                        TextField("Username or an email", text: $username).autocapitalization(.none)
                        TextField("Password", text: $password, onEditingChanged: { _ in
                            if !self.password.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("Website", text: $url).autocapitalization(.none)
                    
                    }
                }
                
                else if itemType == 2 {
                    Section(header: Text("All fields are mandatory.")) {
                        TextField("Card number", text: $cardNumber, onEditingChanged: { _ in
                            if !self.cardNumber.isEmpty && !self.expireDate.isEmpty && !self.cvv.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("Valid until", text: $expireDate, onEditingChanged: { _ in
                            if !self.cardNumber.isEmpty && !self.expireDate.isEmpty && !self.cvv.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("CVV/CVC code", text: $cvv, onEditingChanged: { _ in
                            if !self.cardNumber.isEmpty && !self.expireDate.isEmpty && !self.cvv.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("PIN number", text: $pinNumber, onEditingChanged: { _ in
                            if !self.cardNumber.isEmpty && !self.expireDate.isEmpty && !self.cvv.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                    }
                }
                
                else if itemType == 3 {
                    Section(header: Text("One of the fields is required.")) {
                        TextField("Field 1", text: $field1, onEditingChanged: { _ in
                            if !self.field1.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("Field 2", text: $field2, onEditingChanged: { _ in
                            if !self.field1.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("Field 3", text: $field3, onEditingChanged: { _ in
                            if !self.field1.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                        TextField("Field 4", text: $field4, onEditingChanged: { _ in
                            if !self.field1.isEmpty && !self.itemname.isEmpty {
                                self.buttonDisabled = false
                            }
                            else {
                                self.buttonDisabled = true
                            }
                        }).autocapitalization(.none)
                    }
                }
                
                if itemType != 0 {
                    Section {
                        Toggle(isOn: $toggleIsOn) {
                            Text("Add to a group")
                        }.onTapGesture {
                            if self.toggleIsOn {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.hideGroups = true
                                }
                            }
                            else {
                              self.hideGroups = false
                            }
                            
                        }
                        if !hideGroups {
                            Picker(selection: $group, label: Text("")) {
                                Text("Personal 👤")
                                    .tag(1)
                                Text("Work 💼")
                                    .tag(2)
                                Text("Other...")
                                    .tag(3)
                                }.pickerStyle(SegmentedPickerStyle())
                            .offset(x: toggleIsOn ? 0 : -1000, y: 0).animation(Animation.easeInOut(duration: 0.4))
                            
                            Picker(selection: $favourites, label: Text("")) {
                                Text("Add to Favourites ⭐️")
                                    .tag(true)
                                Text("Don't add")
                                    .tag(false)
                                }.pickerStyle(SegmentedPickerStyle())
                            .offset(x: toggleIsOn ? 0 : -1000, y: 0).animation(Animation.easeInOut(duration: 0.4))
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        if self.itemType == 1 {
                            let newItem = PasswordItem(username: self.username.isEmpty ? nil : self.username, password: self.password, url: self.url.isEmpty ? nil : self.url, itemname: self.itemname, group: self.group == 0 ? nil : self.group, favourites: self.favourites)
                            
                            self.vault.vaultPush(passwordItem: newItem, vault: self.vault)
                        }
                        
                        else if self.itemType == 2 {
                            let newItem = BankCardItem(cardNumber: self.cardNumber, expireDate: self.expireDate, cvv: self.cvv, pinNumber: self.pinNumber.isEmpty ? nil : self.pinNumber, itemname: self.itemname, group: self.group == 0 ? nil : self.group, favourites: self.favourites)
                            
                            self.vault.vaultPush(bankCardItem: newItem, vault: self.vault)
                        }
                        
                        else if self.itemType == 3 {
                            let newItem = OtherItem(field1: self.field1.isEmpty ? nil : self.field1, field2: self.field2.isEmpty ? nil : self.field2, field3: self.field3.isEmpty ? nil : self.field3, field4: self.field4.isEmpty ? nil : self.field4, itemname: self.itemname, group: self.group == 0 ? nil : self.group, favourites: self.favourites)
                            
                            self.vault.vaultPush(otherItem: newItem, vault: self.vault)
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        ButtonUI(name: "Add to Passer")
                        }.disabled(self.buttonDisabled).colorMultiply(self.buttonDisabled ? Color.gray : Color.white).buttonStyle(BorderlessButtonStyle())
                }.padding(20).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
            
                
           
        }
    }
}

struct AddPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        AddPasswordView()
    }
}
