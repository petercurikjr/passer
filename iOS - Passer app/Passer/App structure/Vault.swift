//
//  Vault.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

class Vault: ObservableObject {
    @Published var passwordItems = [PasswordItem]()
    @Published var bankCardItems = [BankCardItem]()
    @Published var otherItems = [OtherItem]()
    private var userDirPaths = [URL]()
    private var vaultFileIsEmpty: Bool = true
    
    init() {
        
    }
    
    init(withFileSystemIntegration: Bool) {
        let filenames = ["jedna.txt","dva.txt","tri.txt"]
        var fileExists = true
        
        for i in 0..<filenames.endIndex {
            ///iOS will find places for our app's data and delete it when the app is deleted. FileManafer.defualt.urls returns an array of all available paths
            userDirPaths.append(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
            self.userDirPaths[i].appendPathComponent(filenames[i])
            
            if !FileManager.default.fileExists(atPath: self.userDirPaths[i].path) {
                fileExists = false
            }
        }
        
        if fileExists {
            ///Fill arrays from device's storage
            do {
                for i in 0..<filenames.endIndex {
                    let stringFromStorage = try String(contentsOf: self.userDirPaths[i])
                    let dataFromStorage = stringFromStorage.data(using: .utf8)
                    
                    if i == 0 {
                        self.passwordItems = try JSONDecoder().decode(Array<PasswordItem>.self, from: dataFromStorage!)
                    }
                    else if i == 1 {
                        self.bankCardItems = try JSONDecoder().decode(Array<BankCardItem>.self, from: dataFromStorage!)
                    }
                    else if i == 2 {
                        self.otherItems = try JSONDecoder().decode(Array<OtherItem>.self, from: dataFromStorage!)
                    }
                }
                
                print("Contents loaded into Passer successfully.")
            }
                
            catch {
                print("An error occured while reading the file from device's storage. Possible corruption of data.", error)
            }
        }
            
        else {
            ///New file
            for i in 0..<filenames.endIndex {
                let success = FileManager.default.createFile(atPath: self.userDirPaths[i].path, contents: nil)
                if success {
                    print("Created a new file \(filenames[i]) successfully.")
                }
                else {
                    print("ERROR: Passer cannot create \(filenames[i]).")
                }
            }
        }
    }
    
    func vaultPush(passwordItem: PasswordItem, vault: Vault) {
        ///Add to the array
        vault.passwordItems.append(passwordItem)
        vaultUpdate(vault: vault)
    }
    
    func vaultPush(bankCardItem: BankCardItem, vault: Vault) {
        ///Add to the array
        vault.bankCardItems.append(bankCardItem)
        vaultUpdate(vault: vault)
    }
    
    func vaultPush(otherItem: OtherItem, vault: Vault) {
        ///Add to the array
        vault.otherItems.append(otherItem)
        vaultUpdate(vault: vault)
    }
    
    ///Updates filesystem with app's changes
    func vaultUpdate(vault: Vault) {
        guard let passwordJson = try? JSONEncoder().encode(self.passwordItems),
            let bankcardJson = try? JSONEncoder().encode(self.bankCardItems),
            let otherJson = try? JSONEncoder().encode(self.otherItems)
            else {
                return
        }
        
        let passwordStr = String(data: passwordJson, encoding: .utf8)!
        let bankcardStr = String(data: bankcardJson, encoding: .utf8)!
        let otherStr = String(data: otherJson, encoding: .utf8)!
        do {
            try passwordStr.write(to: self.userDirPaths[0], atomically: true, encoding: .utf8)
            try bankcardStr.write(to: self.userDirPaths[1], atomically: true, encoding: .utf8)
            try otherStr.write(to: self.userDirPaths[2], atomically: true, encoding: .utf8)
        }
        catch {
            print(error)
        }
        
        ///Print all items in vault
        print("Contents of Other items file:")
        for item in vault.otherItems {
            print(item.getItemName() + ": " + otherStr, terminator:"\n")
        }
        
        print("Contents of Password items file:")
        for item in vault.passwordItems {
            print(item.getItemName() + ": " + passwordStr, terminator:"\n")
        }
        
        print("Contents of Bank card items file:")
        for item in vault.bankCardItems {
            print(item.getItemName() + ": " + bankcardStr, terminator:"\n")
        }
    }
    
    func isEmpty() -> Bool {
        if self.bankCardItems.isEmpty && self.passwordItems.isEmpty && self.otherItems.isEmpty {
            return true
        }
        
        return false
    }
}

class PasserItemsContainer: ObservableObject {
    @Published var passwordItems = [PasswordItem]()
    @Published var bankCardItems = [BankCardItem]()
    @Published var otherItems = [OtherItem]()
}


