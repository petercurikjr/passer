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
    
    private var filenames = ["passworditems_passer.txt","bankcarditems_passer.txt","otheritems_passer.txt","identities.txt"]

    
    init() {
        ///Use in production
        //resolveCryptographicKeys()
        
        getDataIfPresent()
        generateDummyData()
    }
    
    
    private func resolveCryptographicKeys() {
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
    }
    
    
    private func getDataIfPresent() {
        var fileExists: Bool = true
        
        for i in 0..<filenames.endIndex {
            ///iOS will find places for our app's data and delete it when the app is deleted. FileManafer.defualt.urls returns an array of all available paths
            userDirPaths.append(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
            self.userDirPaths[i].appendPathComponent(filenames[i])
            
            if !FileManager.default.fileExists(atPath: self.userDirPaths[i].path) {
                fileExists = false
            }
        }
        
        if fileExists {
            for i in 0..<filenames.endIndex {
                let dataFromStorage = try? Data(contentsOf: self.userDirPaths[i])
                
                ///Use when testing on the emulator
                initAppData(source: dataFromStorage, i: i)
                
                ///Use in production
                //let decryptedDataFromStorage = vaultDecrypt(dataToDecrypt: dataFromStorage)
                //guard decryptedDataFromStorage != nil else {
                //    print("Decryption error. Data may be corrupted or user's vault is empty.")
                //    return
                //}
                //initAppData(source: decryptedDataFromStorage!, i: i)
            }
        }
            
        else {
            ///No files with given filenames found. Create new files with filenames provided
            initFileStructureIfNil()
        }
    }

    
    private func initAppData(source: Data?, i: Int) {
        do {
            if i == 0 {
                self.passwordItems = try JSONDecoder().decode(Array<PasswordItem>.self, from: source!)
            }
            else if i == 1 {
                self.bankCardItems = try JSONDecoder().decode(Array<BankCardItem>.self, from: source!)
            }
            else if i == 2 {
                self.otherItems = try JSONDecoder().decode(Array<OtherItem>.self, from: source!)
            }
            else if i == 3 {
                self.identities = try JSONDecoder().decode(Array<Identity>.self, from: source!)
            }
        }
        
        catch {
            print("An error occured while reading the file from device's storage. Possible corruption of data.", error)
        }
    }
    
    
    private func initFileStructureIfNil() {
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
    
    
    func vaultPush(passwordItem: PasswordItem) {
        ///Add to the array
        passwordItems.append(passwordItem)
        vaultUpdate()
    }
    
    
    func vaultPush(bankCardItem: BankCardItem) {
        ///Add to the array
        bankCardItems.append(bankCardItem)
        vaultUpdate()
    }
    
    
    func vaultPush(otherItem: OtherItem) {
        ///Add to the array
        otherItems.append(otherItem)
        vaultUpdate()
    }
    
    
    func vaultPush(identity: Identity) {
        ///Add to the array
        identities.append(identity)
        vaultUpdate()
    }
    
    
    ///Updates filesystem with app's changes
    func vaultUpdate() {
        ///Encode the whole vault to JSON
        let jsonData = encodeDataToJson()
        guard jsonData.count == 4
            else {
                print("Failed to enocde the vault to Json.")
                return
            }

        ///Use in production
        //saveDataToStorage(jsonData: jsonData.compactMap{$0})
        
        ///Use when testing on the emulator
        saveDataToStoragePlainText(jsonData: jsonData.compactMap{$0})
    }

    
    private func encodeDataToJson() -> [Data?] {
        let passwordJson = try? JSONEncoder().encode(self.passwordItems)
        let bankcardJson = try? JSONEncoder().encode(self.bankCardItems)
        let otherJson = try? JSONEncoder().encode(self.otherItems)
        let identitiesJson = try? JSONEncoder().encode(self.identities)
        
        var jsonArr = [Data?]()
        jsonArr.append(passwordJson)
        jsonArr.append(bankcardJson)
        jsonArr.append(otherJson)
        jsonArr.append(identitiesJson)
        
        return jsonArr
    }
    
    
    private func saveDataToStorage(jsonData: [Data]) {
        ///Encrypt with AES
        let passwordEncrypt = vaultEncrypt(dataToEncrypt: jsonData[0])
        let bankcardEncrypt = vaultEncrypt(dataToEncrypt: jsonData[1])
        let otherEncrypt = vaultEncrypt(dataToEncrypt: jsonData[2])
        let identityEncrypt = vaultEncrypt(dataToEncrypt: jsonData[3])
        
        ///Write file
        do {
            try passwordEncrypt!.write(to: self.userDirPaths[0], options: [.atomicWrite])
            try bankcardEncrypt!.write(to: self.userDirPaths[1], options: [.atomicWrite])
            try otherEncrypt!.write(to: self.userDirPaths[2], options: [.atomicWrite])
            try identityEncrypt!.write(to: self.userDirPaths[3], options: [.atomicWrite])
        }
        
        catch {
            print(error)
        }
    }
    
    ///This method is used only during development and testing on the emulator
    private func saveDataToStoragePlainText(jsonData: [Data]) {
        do {
            try jsonData[0].write(to: self.userDirPaths[0], options: [.atomicWrite])
            try jsonData[1].write(to: self.userDirPaths[1], options: [.atomicWrite])
            try jsonData[2].write(to: self.userDirPaths[2], options: [.atomicWrite])
            try jsonData[3].write(to: self.userDirPaths[3], options: [.atomicWrite])
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
        self.identities.removeAll()
        
        vaultUpdate()
    }
    
    
    private func generateDummyData() {
        var birthDateStr = "1997-11-21"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var birthDate = dateFormatter.date(from: birthDateStr)
        
        var addr = Address(
            country: "Slovakia",
            formatted: "Slovakia",
            locality: "Bratislava",
            postal_code: "83102",
            region: "Bratislavský kraj",
            street_address: "Krátka 1"
        )
        
        var tmp = Identity(
            firstName: "Peter",
            lastName: "Čuřík",
            email: "email@email.com",
            phoneNumber: "+421 904 195 677",
            birthDate: birthDate!,
            username: "petercurikjr",
            gender: Gender.male,
            address: addr
        )

        identities.append(tmp)
        
        birthDateStr = "1998-05-08"
        birthDate = dateFormatter.date(from: birthDateStr)
        
        addr = Address(
            country: "Slovakia",
            formatted: "Slovakia",
            locality: "Budmerice",
            postal_code: "83102",
            region: "Trnavský kraj",
            street_address: "Krátka 1"
        )
        
        tmp = Identity(
            firstName: "Matej",
            lastName: "Friedel",
            email: "mfriedel@email.com",
            phoneNumber: "+421 902 114 701",
            birthDate: birthDate!,
            username: "mathieu",
            gender: Gender.male,
            address: addr
        )
        
        identities.append(tmp)
        
        birthDateStr = "1998-02-27"
        birthDate = dateFormatter.date(from: birthDateStr)
        
        addr = Address(
            country: "Slovakia",
            formatted: "Slovakia",
            locality: "Bratislava",
            postal_code: "83102",
            region: "Bratislavský kraj",
            street_address: "Vesmírna 1"
        )
        
        tmp = Identity(
            firstName: "Ján",
            lastName: "Korček",
            email: "jkorcek@email.com",
            phoneNumber: "+421 905 154 688",
            birthDate: birthDate!,
            username: "janci",
            gender: Gender.male,
            address: addr
        )
        
        identities.append(tmp)
        
        birthDateStr = "1996-12-24"
        birthDate = dateFormatter.date(from: birthDateStr)
        
        addr = Address(
            country: "Slovakia",
            formatted: "Slovakia",
            locality: "Bratislava",
            postal_code: "83102",
            region: "Bratislavský kraj",
            street_address: "Krátka 1"
        )
        
        tmp = Identity(
            firstName: "Martin",
            lastName: "Knoško",
            email: "mknosko@email.com",
            phoneNumber: "+421 910 788 054",
            birthDate: birthDate!,
            username: "Knosky",
            gender: Gender.male,
            address: addr
        )
        
        identities.append(tmp)
        
        birthDateStr = "1997-04-18"
        birthDate = dateFormatter.date(from: birthDateStr)
        
        addr = Address(
            country: "Slovakia",
            formatted: "Slovakia",
            locality: "Devínska Nová Ves",
            postal_code: "83102",
            region: "Bratislavský kraj",
            street_address: "Za Rohom 58/A"
        )
        
        tmp = Identity(
            firstName: "Matej",
            lastName: "Mózer",
            email: "mmozer@email.com",
            phoneNumber: "+421 911 984 410",
            birthDate: birthDate!,
            username: "matejmozer",
            gender: Gender.male,
            address: addr
        )
        
        identities.append(tmp)
        
        birthDateStr = "1989-11-17"
        birthDate = dateFormatter.date(from: birthDateStr)
        
        addr = Address(
            country: "Slovakia",
            formatted: "Slovakia",
            locality: "Prešov",
            postal_code: "75124",
            region: "Prešovský kraj",
            street_address: "Horská 25"
        )
        
        tmp = Identity(
            firstName: "prof. Ing. Pavol",
            lastName: "Zajac, PhD.",
            email: "pz@email.com",
            phoneNumber: "+421 901 051 639",
            birthDate: birthDate!,
            username: "pzuim",
            gender: Gender.male,
            address: addr
        )
        
        identities.append(tmp)
        
        passwordItems.append(
            PasswordItem(
                username: "petercurikjr",
                password: "password123",
                url: "facebook.com",
                itemname: "Facebook login",
                group: nil,
                favourites: true
            )
        )
        
        passwordItems.append(
            PasswordItem(
                username: "peter.curik",
                password: "Uf49pmL3Tk",
                url: nil,
                itemname: "Office PC credentials",
                group: nil,
                favourites: true
            )
        )
        
        passwordItems.append(
            PasswordItem(
                username: "epicgamer",
                password: "worldoftanks",
                url: "discord.com",
                itemname: "Discord gaming profile",
                group: nil,
                favourites: false
            )
        )
        
        passwordItems.append(
            PasswordItem(
                username: "Peter Čuřík",
                password: "stubafei54PCu",
                url: "is.stuba.sk",
                itemname: "FEI STU school",
                group: nil,
                favourites: true
            )
        )
        
        bankCardItems.append(
            BankCardItem(
                cardNumber: "4432 5692 0445 1278",
                expireDate: "04/21",
                cvv: "512",
                pinNumber: "6640",
                itemname: "Credit card",
                group: nil,
                favourites: true)
        )
        
        otherItems.append(
            OtherItem(
                field1: "1553",
                field2: "Basement",
                field3: "Behind picture on the vall",
                field4: "",
                itemname: "My home vault",
                group: nil,
                favourites: false
            )
        )
    }
}


