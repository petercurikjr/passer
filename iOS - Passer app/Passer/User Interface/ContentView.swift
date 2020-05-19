//
//  ContentView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    ///State means "variable can update the view (locally)"
    @State private var showAddPassword = false
    
    @State private var groupSelector = [true,false,false,false]
    @State private var passwordGroups = [PasswordItem]()
    @State private var bankCardGroups = [BankCardItem]()
    @State private var otherGroups = [OtherItem]()
    
    @State private var passwordItemExpand = [PasswordItem]()
    @State private var bankCardItemExpand = [BankCardItem]()
    @State private var otherItemExpand = [OtherItem]()
    @State private var filter = 1
    
    ///Have to create this only because of .sheet bug not acting like a child to this view
    @EnvironmentObject var vault: Vault
    
    var body: some View {
        VStack {
            if(self.vault.isEmpty()) {
                EmptyVault()
            }
                
            else {
                VStack {
                    HStack {
                        Text("Passer")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                        Button(action: {
                            self.showAddPassword = true
                        }) {
                            Image(systemName: "plus")
                        }
                            ///Sheets are supposed to be understood as children to a view which creates them. But it does not work for now, Apple promised a fix for this. Until then, we have to pass the EnvironmentObject by hand as a parameter to a view
                            ///Otherwise, we would not have to create EnvironmentObject in ContentView, since it is already in AppView.
                            .sheet(isPresented: self.$showAddPassword) {
                                AddPasserItemView().environmentObject(self.vault)
                        }
                    }
                }.padding(.horizontal, 30).multilineTextAlignment(.leading).padding(.vertical).padding(.top)
                
                VStack {
                    HStack {
                        Button(action: {
                            for i in 0..<self.groupSelector.count {
                                self.groupSelector[i] = false
                            }
                            self.groupSelector[0].toggle()
                            
                        }) {
                            GroupsSelector(groupName: "All groups", count: vault.passwordItems.count + vault.bankCardItems.count + vault.otherItems.count,
                                           color1: groupSelector[0] ? "blue1" : "gray1",
                                           color2: groupSelector[0] ? "blue2" : "gray2", emoji: "📝")
                        }.buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            for i in 0..<self.groupSelector.count {
                                self.groupSelector[i] = false
                            }
                            self.groupSelector[3].toggle()
                            self.passwordGroups = self.vault.passwordItems.filter { $0.getFavourites() == true }
                            self.bankCardGroups = self.vault.bankCardItems.filter { $0.getFavourites() == true }
                            self.otherGroups = self.vault.otherItems.filter { $0.getFavourites() == true }
                            
                        }) {
                            GroupsSelector(groupName: "Favourites", count:
                                ((self.filter == 1 || self.filter == 2) ? vault.passwordItems.filter { $0.getFavourites() == true }.count : 0) +
                                    ((self.filter == 1 || self.filter == 3) ? vault.bankCardItems.filter { $0.getFavourites() == true }.count : 0) +
                                    ((self.filter == 1 || self.filter == 4) ? vault.otherItems.filter { $0.getFavourites() == true }.count : 0),
                                           color1: groupSelector[3] ? "hot1" : "gray1",
                                           color2: groupSelector[3] ? "hot2" : "gray2", emoji: "⭐️")
                        }.buttonStyle(PlainButtonStyle())
                    }
                    HStack {
                        Button(action: {
                            for i in 0..<self.groupSelector.count {
                                self.groupSelector[i] = false
                            }
                            self.groupSelector[1].toggle()
                            self.passwordGroups = self.vault.passwordItems.filter { $0.getGroup() == 1 }
                            self.bankCardGroups = self.vault.bankCardItems.filter { $0.getGroup() == 1 }
                            self.otherGroups = self.vault.otherItems.filter { $0.getGroup() == 1 }
                        }) {
                            GroupsSelector(groupName: "Personal", count:
                                ((self.filter == 1 || self.filter == 2) ? vault.passwordItems.filter { $0.getGroup() == 1 }.count : 0) +
                                    ((self.filter == 1 || self.filter == 3) ? vault.bankCardItems.filter { $0.getGroup() == 1 }.count : 0) +
                                    ((self.filter == 1 || self.filter == 4) ? vault.otherItems.filter { $0.getGroup() == 1 }.count : 0),
                                           color1: groupSelector[1] ? "blue1" : "gray1",
                                           color2: groupSelector[1] ? "blue2" : "gray2", emoji: "👤")
                        }.buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            for i in 0..<self.groupSelector.count {
                                self.groupSelector[i] = false
                            }
                            self.groupSelector[2].toggle()
                            self.passwordGroups = self.vault.passwordItems.filter { $0.getGroup() == 2 }
                            self.bankCardGroups = self.vault.bankCardItems.filter { $0.getGroup() == 2 }
                            self.otherGroups = self.vault.otherItems.filter { $0.getGroup() == 2 }
                            
                        }) {
                            GroupsSelector(groupName: "Work", count:
                                ((self.filter == 1 || self.filter == 2) ? vault.passwordItems.filter { $0.getGroup() == 2 }.count : 0) +
                                    ((self.filter == 1 || self.filter == 3) ? vault.bankCardItems.filter { $0.getGroup() == 2 }.count : 0) +
                                    ((self.filter == 1 || self.filter == 4) ? vault.otherItems.filter { $0.getGroup() == 2 }.count : 0),
                                           color1: groupSelector[2] ? "blue1" : "gray1",
                                           color2: groupSelector[2] ? "blue2" : "gray2", emoji: "💼")
                        }.buttonStyle(PlainButtonStyle())
                    }
                }.padding(.horizontal)
                
                Picker(selection: $filter, label: Text("")) {
                    Text("All items")
                        .tag(1)
                    Text("Passwords")
                        .tag(2)
                    Text("Bank cards")
                        .tag(3)
                    Text("Other")
                        .tag(4)
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
                
                List {
                    if filter == 1 || filter == 2 {
                        Section(header: Text("Password items")) {
                            ForEach(self.groupSelector[0] ? self.vault.passwordItems : self.passwordGroups) { item in
                                VStack {
                                    HStack {
                                        Text(item.getItemName())
                                        Spacer()
                                        if item.passwordStrength().count == 1 && !item.passwordStrength().contains(.short) {
                                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.yellow)
                                        }
                                        else if item.passwordStrength().count > 1 || item.passwordStrength().contains(.short) {
                                            Image(systemName: "xmark.seal.fill").foregroundColor(Color.red)
                                        }
                                    }.contentShape(Rectangle()).padding(2)
                                        .onTapGesture {
                                            self.expandCollapse(item)
                                    }
                                    PasserItemCell(expanded: self.passwordItemExpand.contains(item), passwordItem: item, bankCardItem: nil, otherItem: nil)
                                        .animation(Animation.easeInOut(duration: 0.3))
                                }
                            }
                            .onDelete { indexSet in
                                self.vault.passwordItems.remove(atOffsets: indexSet)
                                self.vault.vaultUpdate(vault: self.vault)
                            }
                        }
                    }
                    
                    if filter == 1 || filter == 3 {
                        Section(header: Text("Bank card items")) {
                            ForEach(self.groupSelector[0] ? self.vault.bankCardItems : self.bankCardGroups) { item in
                                VStack {
                                    HStack {
                                        Text(item.getItemName())
                                        Spacer()
                                        if item.bankCardExpireDate() == .expiresoon {
                                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.yellow)
                                        }
                                        else if item.bankCardExpireDate() == .expired {
                                            Image(systemName: "xmark.seal.fill").foregroundColor(Color.red)
                                        }
                                    }.contentShape(Rectangle()).padding(2)
                                        .onTapGesture {
                                            self.expandCollapse(item)
                                    }
                                    PasserItemCell(expanded: self.bankCardItemExpand.contains(item), passwordItem: nil, bankCardItem: item, otherItem: nil)
                                        .animation(Animation.easeInOut(duration: 0.3).delay(0.1))
                                }
                            }.onDelete { indexSet in
                                self.vault.bankCardItems.remove(atOffsets: indexSet)
                                self.vault.vaultUpdate(vault: self.vault)
                            }
                        }
                    }
                    
                    if filter == 1 || filter == 4 {
                        Section(header: Text("Other items")) {
                            ForEach(self.groupSelector[0] ? self.vault.otherItems : self.otherGroups) { item in
                                VStack {
                                    HStack {
                                        Text(item.getItemName())
                                        Spacer()
                                    }.contentShape(Rectangle()).padding(2)
                                        .onTapGesture {
                                            self.expandCollapse(item)
                                    }
                                    PasserItemCell(expanded: self.otherItemExpand.contains(item), passwordItem: nil, bankCardItem: nil, otherItem: item)
                                        .animation(Animation.easeInOut(duration: 0.3).delay(0.1))
                                }
                            }.onDelete { indexSet in
                                self.vault.otherItems.remove(atOffsets: indexSet)
                                self.vault.vaultUpdate(vault: self.vault)
                            }
                        }
                    }
                }.listStyle(GroupedListStyle()).onAppear { UITableView.appearance().separatorStyle = .singleLine
                }
            }
        }
    }
    
    private func expandCollapse(_ item: AnyObject) {
        if ((item as? PasswordItem) != nil) {
            if passwordItemExpand.contains(item as! PasswordItem) {
                passwordItemExpand.remove(at: passwordItemExpand.firstIndex(of: item as! PasswordItem)!)
            } else {
                passwordItemExpand.append(item as! PasswordItem)
            }
        }
            
        else if ((item as? BankCardItem) != nil) {
            if bankCardItemExpand.contains(item as! BankCardItem) {
                bankCardItemExpand.remove(at: bankCardItemExpand.firstIndex(of: item as! BankCardItem)!)
            } else {
                bankCardItemExpand.append(item as! BankCardItem)
            }
        }
            
        else if ((item as? OtherItem) != nil) {
            if otherItemExpand.contains(item as! OtherItem) {
                otherItemExpand.remove(at: otherItemExpand.firstIndex(of: item as! OtherItem)!)
            } else {
                otherItemExpand.append(item as! OtherItem)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .light)
    }
}
