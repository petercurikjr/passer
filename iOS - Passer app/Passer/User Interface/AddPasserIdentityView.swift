//
//  AddPasserIdentityView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 07/03/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct AddPasserIdentityView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vault: Vault
    
    ///Identity - basic info
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var birthDate: Date = Date()
    
    ///Identity - contact
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    ///Identity - address
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var zipCode: String = ""
    @State private var country: String = ""
    
    ///Booleans
    @State private var toggleIsOn: Bool = false
    @State var showDatePicker = false
    
    @State private var pickedGender = Gender.unspecified
    
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
                    Text("New Identity")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                }

                HStack {
                    Text("Your created identity will stay only with you. Passer does not store any of your data on its servers.")
                        .font(.subheadline)
                    Spacer()
                }
            }.padding(30).multilineTextAlignment(.leading).padding(.top)
            
            Form {
                Section(header: Text("Basic info")) {
                    Text("First name:")
                    TextField("", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Last name:")
                    TextField("", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Username:")
                    TextField("", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Date of birth:")
                    Button(action: {
                        showDatePicker.toggle()
                    }) {
                        Text("Choose by clicking here")
                    }
                    
                    if showDatePicker {
                        DatePicker("", selection: $birthDate)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .animation(.easeInOut)
                    }
                    
                    Group {
                        Text("Gender")
                        Picker(selection: $pickedGender, label: Text(""), content: {
                            Text("Male")
                                .tag(Gender.male)
                            Text("Female")
                                .tag(Gender.female)
                            Text("Unspecified")
                                .tag(Gender.unspecified)
                        }).pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                
                Section(header: Text("Contact")) {
                    Text("Email:")
                    TextField("", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Phone number:")
                    TextField("", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Address")) {
                    Text("Street:")
                    TextField("", text: $street)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("City:")
                    TextField("", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("ZIP Code:")
                    TextField("", text: $zipCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Country:")
                    TextField("", text: $country)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section {
                    Button(action: {
                        let address = Address(country: country, formatted: "", locality: city, postal_code: zipCode, region: "", street_address: street)
                        let newIdentity = Identity(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            phoneNumber: phoneNumber,
                            birthDate: birthDate,
                            username: username,
                            gender: pickedGender,
                            address: address)
                        
                        self.vault.vaultPush(identity: newIdentity)
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        ButtonUI(name: "Add to Passer")
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).buttonStyle(BorderlessButtonStyle())
                }.padding(20)
            }
            
        }
    }
}

struct AddPasserIdentityView_Previews: PreviewProvider {
    static var previews: some View {
        AddPasserIdentityView()
    }
}
