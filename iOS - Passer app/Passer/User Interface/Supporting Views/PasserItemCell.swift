//
//  PasserItemView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 02/05/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct PasserItemCell: View {
    
    let expanded: Bool
    let passwordItem: PasswordItem?
    let bankCardItem: BankCardItem?
    let otherItem: OtherItem?
    
    @State var chosenName = ""
    
    @State private var showOutsider = false
    @State private var showEdit = false
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        VStack {
            if expanded && passwordItem != nil {
                VStack {
                    VStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Username or an email: ")
                                    .bold().font(.headline)
                                Text(passwordItem!.getUsername() ?? "")
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("Password: ")
                                    .bold().font(.headline)
                                Text(passwordItem!.getPassword())
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("Website: ")
                                    .bold().font(.headline)
                                Text(passwordItem!.getUrl() ?? "")
                            }
                        }.padding().padding(.top).padding(.bottom)
                        
                        Divider()
                        
                        VStack {
                            if self.passwordItem!.passwordStrength().isEmpty {
                                HStack {
                                    Text("Password strength: ").bold()
                                    Text("Good").foregroundColor(Color.green).bold()
                                }
                            }
                                
                            else if self.passwordItem!.passwordStrength().count == 1 && !self.passwordItem!.passwordStrength().contains(.short) {
                                HStack {
                                   Text("Password strength: ").bold()
                                   Text("Vulnerable").foregroundColor(Color.yellow).bold()
                                }
                                if self.passwordItem!.passwordStrength().contains(.nolower) {
                                    Text("No lowercase letters.")
                                }
                                else if self.passwordItem!.passwordStrength().contains(.noupper) {
                                    Text("No uppercase letters.")
                                }
                                else if self.passwordItem!.passwordStrength().contains(.nonumbers) {
                                    Text("No numbers.")
                                }
                            }
                            else if self.passwordItem!.passwordStrength().count > 1 || self.passwordItem!.passwordStrength().contains(.short) {
                                HStack {
                                    Text("Password strength: ").bold()
                                    Text("Critical").foregroundColor(Color.red).bold()
                                }
                                if self.passwordItem!.passwordStrength().contains(.short) {
                                    Text("Password too short.")
                                }
                                if self.passwordItem!.passwordStrength().contains(.nolower) {
                                    Text("No lowercase letters.")
                                }
                                if self.passwordItem!.passwordStrength().contains(.noupper) {
                                    Text("No uppercase letters.")
                                }
                                if self.passwordItem!.passwordStrength().contains(.nonumbers) {
                                    Text("No numbers.")
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            self.showOutsider = true
                        }) {
                            ButtonUI(name: "Outsider")
                            
                        }.scaleEffect(0.8)
                        .buttonStyle(BorderlessButtonStyle())
                        /*
                        Button(action: {
                            print("Edit button tapped")
                            self.showEdit = true
                        }) {
                            ButtonUI(name: "Edit")
                        }.scaleEffect(0.8)
                        .buttonStyle(BorderlessButtonStyle())
                         */
                    }
                }.background(Color("gray2").opacity(0.1).shadow(radius: 30)).cornerRadius(25)
                .onAppear(perform: {
                    self.chosenName = self.passwordItem!.getItemName()
                })
            }
                    
            else if expanded && bankCardItem != nil {
                VStack {
                    VStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Card number: ")
                                    .bold().font(.headline)
                                Text(bankCardItem!.getCardNumber())
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("Expire date: ")
                                    .bold().font(.headline)
                                Text(bankCardItem!.getExpireDate())
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("CVV/CVC number: ")
                                    .bold().font(.headline)
                                Text(bankCardItem!.getCvv())
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("PIN: ")
                                    .bold().font(.headline)
                                Text(bankCardItem!.getPin() ?? "")
                            }
                        }.padding().padding(.top).padding(.bottom)
                        
                        Divider()
                        
                        VStack {
                            Text("Card state:")
                                .bold()
                            
                            if self.bankCardItem!.bankCardExpireDate() == .ok {
                                Text("OK")
                                    .foregroundColor(Color.green).bold()
                            }
                            else if self.bankCardItem!.bankCardExpireDate() == .expiresoon {
                                Text("Will expire soon")
                                    .foregroundColor(Color.yellow).bold()
                            }
                            else {
                                Text("Expired")
                                    .foregroundColor(Color.red).bold()
                            }
                           
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            self.showOutsider = true
                        }) {
                            ButtonUI(name: "Outsider")
                            
                        }.scaleEffect(0.8)
                        .buttonStyle(BorderlessButtonStyle())
                        /*
                        Button(action: {
                            print("Edit button tapped")
                            self.showEdit = true
                        }) {
                            ButtonUI(name: "Edit")
                        }.scaleEffect(0.8)
                        .buttonStyle(BorderlessButtonStyle())
                        */
                    }
                }.background(Color("gray2").opacity(0.1).shadow(radius: 30)).cornerRadius(25)
                .onAppear(perform: {
                    self.chosenName = self.bankCardItem!.getItemName()
                })
            }
                
            else if expanded && otherItem != nil {
                VStack {
                    VStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Field1: ")
                                    .bold().font(.headline)
                                Text(otherItem!.getField1() ?? "")
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("Field2: ")
                                    .bold().font(.headline)
                                Text(otherItem!.getField2() ?? "")
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("Field3: ")
                                    .bold().font(.headline)
                                Text(otherItem!.getField3() ?? "")
                            }.padding(.bottom)
                            VStack(alignment: .leading) {
                                Text("Field4: ")
                                    .bold().font(.headline)
                                Text(otherItem!.getField4() ?? "")
                            }
                        }.padding().padding(.top).padding(.bottom)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            self.showOutsider = true
                        }) {
                            ButtonUI(name: "Outsider")
                            
                        }.scaleEffect(0.8)
                        .buttonStyle(BorderlessButtonStyle())
                        /*
                        Button(action: {
                            print("Edit button tapped")
                            self.showEdit = true
                        }) {
                            ButtonUI(name: "Edit")
                        }.scaleEffect(0.8)
                        .buttonStyle(BorderlessButtonStyle())
                         */
                    }
                    
                }.background(Color("gray2").opacity(0.1).shadow(radius: 30)).cornerRadius(25)
                .onAppear(perform: {
                    self.chosenName = self.otherItem!.getItemName()
                })
            }
        }
        .sheet(isPresented: self.$showEdit) {
            EditPasserItemView()
                .environmentObject(self.vault)
        }
        .sheet(isPresented: self.$showOutsider) {
            OutsiderFirstView(chosenPassword: self.passwordItem, chosenBankCard: self.bankCardItem, chosenOther: self.otherItem, chosenName: self.chosenName)
                .environmentObject(self.vault)
        }
 
    }
}

struct PasserItemCell_Previews: PreviewProvider {
    static var previews: some View {
        PasserItemCell(expanded: true, passwordItem: nil, bankCardItem: nil, otherItem: nil)
    }
}
