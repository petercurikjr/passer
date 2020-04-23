//
//  Vault.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 04/03/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

class Vault: ObservableObject {
    @Published private var items: [PasswordItem]
    private var userDirPath: URL?
    private var vaultFileIsEmpty: Bool = true
    
    init() {
        ///Create a vault with empty password array
        let itemsArr = [PasswordItem]()
        self.items = itemsArr
        let filename = "passerdata.txt"
        
        ///iOS will find a place for our app's data and delete it when the app is deleted. FileManafer.defualt.urls returns an array of all available paths, but we care about the first one. That's why ".first" at the end of the line is present
        self.userDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if self.userDirPath == nil {
            print("Couldn't find a place for Passer app data")
        }
        self.userDirPath!.appendPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: self.userDirPath!.path) {
            ///Fill the array from device's storage
            do {
                let dataFromStorage = try String(contentsOf: self.userDirPath!).data(using: .utf8)

                print(try String(contentsOf: self.userDirPath!))
                self.items = try JSONDecoder().decode(Array<PasswordItem>.self, from: dataFromStorage!)
             
                print("Contents of \(filename):")
                for item in self.items {
                    print(item.getItemName())
                }
            }

            catch {
                print("An error occured while reading the file from device's storage. Possible corruption of data.\n", error)
            }
        }
        
        else {
            ///New file
            let success = FileManager.default.createFile(atPath: self.userDirPath!.path, contents: nil)
            if success {
                print("Created a new file successfully.")
            }
            else {
                print("ERROR Passer cannot create passerdata.txt.")
            }
        }
 
    }
    
    func vaultPush(item: PasswordItem, vault: Vault) {
        ///Add to the array
        vault.items.append(item)
        
        ///Convert to JSON and save to storage
        guard let jsonConverted = try? JSONEncoder().encode(item) else {
            return
        }
        
        var jsonStr = String(data: jsonConverted, encoding: .utf8)!
        
        do {
            let fileHandle = try FileHandle(forWritingTo: self.userDirPath!)
            let openingBracket = "["
            let closingBracket = "]"
            
            if vaultFileIsEmpty {
                jsonStr = openingBracket + jsonStr + closingBracket
                try jsonStr.write(to: self.userDirPath!, atomically: true, encoding: .utf8)
                vaultFileIsEmpty = false
            }
            else {
                ///Add "," to the start and "]" to the end of a new item
                jsonStr = "," + jsonStr + closingBracket
                
                ///Moves pointer to the end of file -1 (to overwrite closing bracket "]")
                try fileHandle.seek(toOffset: fileHandle.seekToEndOfFile()-1)
                fileHandle.write(jsonStr.data(using: .utf8)!)
            }
            fileHandle.closeFile()
        }
        catch {
            print(error)
        }
        
        ///Print all items in vault
        for item in vault.items {
            print(item.getItemName() + ": " + jsonStr, terminator:"\n")
        }
        print("\n")
    }
    
    func vaultUpdate() {
        //json should be a dict --> id: passworditem
        //so we can search by id and update that item
        //and write back to a file
    }
    
}


