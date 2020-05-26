//
//  Networking.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 01/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

final class ServerDelegate: ObservableObject {
    
    ///Published variables can update views which have an @ObservedObject instance of this class. A class needs to conform to ObservableObject in order this to work
    ///This can be also achieved with publishers from Combine framework, but this technique offers a super-easy approch to this problem (which, of course means less control and features of publishing and subscribing, but this is sufficient for our purposes)
    @Published var approvedByServer: SixdigitAuth? = nil
    @Published var serverDown: Bool = false
    
    private var sixdigitStructure: SixdigitAuth? = nil
    
    init() {
        
    }
    
    func newSixdigitCode(passwordItems: [PasswordItem]?, bankCardItems: [BankCardItem]?, otherItems: [OtherItem]?) {
        
        self.sixdigitStructure = generateStruct(passwordItems: passwordItems, bankCardItems: bankCardItems, otherItems: otherItems)
        let toJSON = sixdigitJSON(input: self.sixdigitStructure!)
        postToServer(jsonToUpload: toJSON!, sixdigitStructure: self.sixdigitStructure!)
    }
    
    func postToServer(jsonToUpload: Data, sixdigitStructure: SixdigitAuth) {
        var request = URLRequest(url: URL(string: "https://api-passer.herokuapp.com/sixdigit")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonToUpload;
                
        ///Timeout settings
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(10)
        let session = URLSession(configuration: configuration)
        
        let task = session.uploadTask(with: request, from: jsonToUpload, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
                self.processServerResult(sixdigitStructure: nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                self.processServerResult(sixdigitStructure: nil)
                print("server error")
                return
            }
            
            ///Success
            if data != nil {
                self.processServerResult(sixdigitStructure: sixdigitStructure)
                print(String(data: data!, encoding: .utf8)!)
            }
        })
        task.resume()
    }
    
    func postToServer(sessionID: Data) {
        var request = URLRequest(url: URL(string: "https://api-passer.herokuapp.com/qr")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sessionID;
                
        ///Timeout settings
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(10)
        let session = URLSession(configuration: configuration)
        
        let task = session.uploadTask(with: request, from: sessionID, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print("server error")
                return
            }
            
            ///Success
            if data != nil {
                print(String(data: data!, encoding: .utf8)!)
            }
        })
        task.resume()
    }
    
    func processServerResult(sixdigitStructure: SixdigitAuth?) {
        ///Switch to the main thread
        DispatchQueue.main.async {
            guard sixdigitStructure != nil else {
                self.serverDown = true
                return
            }
            
            self.serverDown = false
            self.approvedByServer = sixdigitStructure
        }
    }
    
}






