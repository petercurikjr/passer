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

    @Published var identities = [Identity]()
    private var userDirPaths = [URL]()
    private var vaultFileIsEmpty: Bool = true
    
    private var privateKey: SecKey? = nil
    private var publicKey: SecKey? = nil

    init() {
        let filenames = ["passworditems_passer.txt","bankcarditems_passer.txt","otheritems_passer.txt"]
        var fileExists = true
        
        /*
        let privateKey = loadKey(name: "passerkey")
        if privateKey == nil {
            guard let initialKey = try? createAndStoreKey(name: "passerkey", requiresBiometry: false) else {
                print("Couldn't create a private key.")
                return
            }
            self.privateKey = initialKey
        }
        
        else {
            self.privateKey = privateKey
        }

        guard let publicKey = SecKeyCopyPublicKey(self.privateKey!) else {
            print("Couldn't create a public key from the private key.")
            return
        }
        
        self.publicKey = publicKey
         */
        
        
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
                    let dataFromStorage = try Data(contentsOf: self.userDirPaths[i])
                    /*
                    let decryptedDataFromStorage = vaultDecrypt(dataToDecrypt: dataFromStorage)
                    guard decryptedDataFromStorage != nil else {
                        print("Decryption error. Data may be corrupted or user's vault is empty.")
                        return
                    }
                    
                    if i == 0 {
                        self.passwordItems = try JSONDecoder().decode(Array<PasswordItem>.self, from: decryptedDataFromStorage!)
                    }
                    else if i == 1 {
                        self.bankCardItems = try JSONDecoder().decode(Array<BankCardItem>.self, from: decryptedDataFromStorage!)
                    }
                    else if i == 2 {
                        self.otherItems = try JSONDecoder().decode(Array<OtherItem>.self, from: decryptedDataFromStorage!)
                    }
                    */
                    if i == 0 {
                        self.passwordItems = try JSONDecoder().decode(Array<PasswordItem>.self, from: dataFromStorage)
                    }
                    else if i == 1 {
                        self.bankCardItems = try JSONDecoder().decode(Array<BankCardItem>.self, from: dataFromStorage)
                    }
                    else if i == 2 {
                        self.otherItems = try JSONDecoder().decode(Array<OtherItem>.self, from: dataFromStorage)
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
        ///To JSON
        guard let passwordJson = try? JSONEncoder().encode(self.passwordItems),
            let bankcardJson = try? JSONEncoder().encode(self.bankCardItems),
            let otherJson = try? JSONEncoder().encode(self.otherItems)
            else {
                return
        }
         
        /*
        ///To Ciphertext
        let passwordEncrypt = vaultEncrypt(dataToEncrypt: passwordJson)
        let bankcardEncrypt = vaultEncrypt(dataToEncrypt: bankcardJson)
        let otherEncrypt = vaultEncrypt(dataToEncrypt: otherJson)
         */
        
        ///Write file
        do {
            /*
            try passwordEncrypt!.write(to: self.userDirPaths[0], options: [.atomicWrite])
            try bankcardEncrypt!.write(to: self.userDirPaths[1], options: [.atomicWrite])
            try otherEncrypt!.write(to: self.userDirPaths[2], options: [.atomicWrite])
             */
            
            try passwordJson.write(to: self.userDirPaths[0], options: [.atomicWrite])
            try bankcardJson.write(to: self.userDirPaths[1], options: [.atomicWrite])
            try otherJson.write(to: self.userDirPaths[2], options: [.atomicWrite])
        }
        catch {
            print(error)
        }
    }
    
    private func vaultEncrypt(dataToEncrypt: Data) -> Data? {
        ///Check for algorithm support
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorX963SHA256AESGCM
        guard SecKeyIsAlgorithmSupported(self.publicKey!, .encrypt, algorithm) else {
            print("Selected algorithm is not supported.")
            return nil
        }
        
        ///Encrypt process
        var error: Unmanaged<CFError>?

        return SecKeyCreateEncryptedData(self.publicKey!, algorithm, dataToEncrypt as CFData, &error) as Data?
    }
    
    private func vaultDecrypt(dataToDecrypt: Data?) -> Data? {
        ///Check for algorithm support
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorX963SHA256AESGCM
        guard SecKeyIsAlgorithmSupported(self.privateKey!, .decrypt, algorithm) else {
            print("Selected algorithm is not supported.")
            return nil
        }
        
        ///Decrypt process
        var error: Unmanaged<CFError>?
        guard dataToDecrypt != nil else {
            return nil
        }
        
        return SecKeyCreateDecryptedData(self.privateKey!, algorithm, dataToDecrypt! as CFData, &error) as Data?
    }
    
    private func createAndStoreKey(name: String, requiresBiometry: Bool = false) throws -> SecKey {

        let flags: SecAccessControlCreateFlags
        if #available(iOS 11.3, *) {
            flags = requiresBiometry ? [.privateKeyUsage, .biometryCurrentSet] : .privateKeyUsage
        }
        else {
            flags = requiresBiometry ? [.privateKeyUsage, .touchIDCurrentSet] : .privateKeyUsage
        }
        
        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,kSecAttrAccessibleWhenUnlockedThisDeviceOnly,flags,nil)!
        let tag = name.data(using: .utf8)!
        
        ///Attributes of the key
        let attributes: [String: Any] = [
            ///Size of the key is 256 bits
            kSecAttrKeyType as String           : kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String     : 256,
            kSecAttrTokenID as String           : kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String : [
                kSecAttrIsPermanent as String       : true,
                kSecAttrApplicationTag as String    : tag,
                kSecAttrAccessControl as String     : access
            ]
        ]
        
        var error: Unmanaged<CFError>?
        
        ///Creating a private key in Secure Enclave
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return privateKey
    }
    
    private func loadKey(name: String) -> SecKey? {
        let keyName = name.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : keyName,
            kSecAttrKeyType as String           : kSecAttrKeyTypeEC,
            kSecReturnRef as String             : true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        return (item as! SecKey)
    }
    
    func isEmpty() -> Bool {
        if self.bankCardItems.isEmpty && self.passwordItems.isEmpty && self.otherItems.isEmpty {
            return true
        }
        
        return false
    }
    
    func vaultErase() {
        self.passwordItems.removeAll()
        self.bankCardItems.removeAll()
        self.otherItems.removeAll()
    }
}


