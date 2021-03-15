//
//  OutsiderFirstView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 03/05/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct OutsiderFirstView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vault: Vault
    
    let chosenPassword: PasswordItem?
    let chosenBankCard: BankCardItem?
    let chosenOther: OtherItem?
    let chosenName: String
    
    @State var chosenPasswords = [PasswordItem]()
    @State var chosenBankCards = [BankCardItem]()
    @State var chosenOthers = [OtherItem]()
    
    @State private var showOutsiderNextView = false
    @State var checkedAll = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                    }) {
                        Image(systemName: "arrow.left")
                            .padding(.top, 20)
                            .padding(.leading, 25)
                    }.opacity(0).disabled(true)
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
                        Text("A powerful tool which lets you access your secrets on a device without Passer.")
                            .font(.subheadline)
                        Spacer()
                    }
                }.padding(30).multilineTextAlignment(.leading)
                
                Text("Which items would you like to access outside Passer?")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40).padding()
                Button(action: {
                }) {
                    HStack {
                        Image(systemName: "checkmark.square")
                        Text(self.chosenName)
                    }
                }.disabled(true)
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
                    
                    Section(header: Text("Password items")) {
                        ForEach(self.vault.passwordItems) { item in
                            if item != self.chosenPassword {
                                Button(action: {
                                    self.selectDeselect(item)
                                }) {
                                    HStack {
                                        Image(systemName: self.chosenPasswords.contains(item) ? "checkmark.square": "square")
                                        Text(item.getItemName())
                                    }
                                }
                            }
                        }
                    }
                    Section(header: Text("Bank card items")) {
                        ForEach(self.vault.bankCardItems) { item in
                            if item != self.chosenBankCard {
                                Button(action: {
                                    self.selectDeselect(item)
                                }) {
                                    HStack {
                                        Image(systemName: self.chosenBankCards.contains(item) ? "checkmark.square": "square")
                                        Text(item.getItemName())
                                    }
                                }
                            }
                        }
                    }
                    Section(header: Text("Other items")) {
                        ForEach(self.vault.otherItems) { item in
                            if item != self.chosenOther {
                                Button(action: {
                                    self.selectDeselect(item)
                                }) {
                                    HStack {
                                        Image(systemName: self.chosenOthers.contains(item) ? "checkmark.square": "square")
                                        Text(item.getItemName())
                                    }
                                }
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
                
                VStack {
                    Button(action: {
                        self.showOutsiderNextView.toggle()
                    }) {
                        ButtonUI(name: "Proceed")
                    }
                }
                Spacer()
            }.opacity(showOutsiderNextView ? 0 : 1).animation(Animation.easeInOut(duration: 0.7))
            
            OutsiderView(goBack: self.$showOutsiderNextView, chosenPasswords: self.chosenPasswords, chosenBankCards: self.chosenBankCards, chosenOthers: self.chosenOthers).opacity(showOutsiderNextView ? 1 : 0).animation(Animation.easeInOut(duration: 0.7))
        }.onAppear(perform: {
            if self.chosenPassword != nil {
                self.chosenPasswords.append(self.chosenPassword!)
            }
            else if self.chosenBankCard != nil {
                self.chosenBankCards.append(self.chosenBankCard!)
            }
            else if self.chosenOther != nil {
                self.chosenOthers.append(self.chosenOther!)
            }
        })
    }
    
    private func selectDeselect(_ item: AnyObject) {
        if ((item as? PasswordItem) != nil) {
            if chosenPasswords.contains(item as! PasswordItem) {
                chosenPasswords.remove(at: chosenPasswords.firstIndex(of: item as! PasswordItem)!)
            } else {
                chosenPasswords.append(item as! PasswordItem)
            }
        }
            
        else if ((item as? BankCardItem) != nil) {
            if chosenBankCards.contains(item as! BankCardItem) {
                chosenBankCards.remove(at: chosenBankCards.firstIndex(of: item as! BankCardItem)!)
            } else {
                chosenBankCards.append(item as! BankCardItem)
            }
        }
            
        else if ((item as? OtherItem) != nil) {
            if chosenOthers.contains(item as! OtherItem) {
                chosenOthers.remove(at: chosenOthers.firstIndex(of: item as! OtherItem)!)
            } else {
                chosenOthers.append(item as! OtherItem)
            }
        }
    }
    
    private func selectDeselectAll() {
        self.chosenPasswords.removeAll()
        self.chosenBankCards.removeAll()
        self.chosenOthers.removeAll()
        
        if self.checkedAll {
            self.chosenPasswords.append(contentsOf: vault.passwordItems)
            self.chosenBankCards.append(contentsOf: vault.bankCardItems)
            self.chosenOthers.append(contentsOf: vault.otherItems)
        }
        
        else {
            if self.chosenPassword != nil { self.chosenPasswords.append(self.chosenPassword!) }
            else if self.chosenBankCard != nil { self.chosenBankCards.append(self.chosenBankCard!) }
            else if self.chosenOther != nil { self.chosenOthers.append(self.chosenOther!) }
        }
    }
}

struct OutsiderFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OutsiderFirstView(chosenPassword: nil, chosenBankCard: nil, chosenOther: nil, chosenName: "")
    }
}
