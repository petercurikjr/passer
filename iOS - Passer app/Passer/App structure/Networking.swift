//
//  Networking.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 01/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import SocketIO

final class ServerDelegate: ObservableObject {
    
    ///Published variables can update views which have an @ObservedObject instance of this class. A class needs to conform to ObservableObject in order this to work
    ///This can be also achieved with publishers from Combine framework, but this technique offers a super-easy approch to this problem (which, of course means less control and features of publishing and subscribing, but this is sufficient for our purposes)
    @Published var serverDown: Bool = false
    @Published var response: String?
    @Published var timestamp: Date?
    
    init() {}
    
    private var passerItemsRequestBody: SixdigitAuth? = nil
    
    func generatePasserItemsRequestBody(passwordItems: [PasswordItem]? = nil, bankCardItems: [BankCardItem]? = nil, otherItems: [OtherItem]? = nil) {
        if self.passerItemsRequestBody == nil {
            self.passerItemsRequestBody = generatePasserItemsStruct(passwordItems: passwordItems, bankCardItems: bankCardItems, otherItems: otherItems)
        }
        
        postToServer(jsonToUpload: sixdigitToJSON(input: self.passerItemsRequestBody!)!, requestBody: self.passerItemsRequestBody!)
    }
    
    
    func postToServer(jsonToUpload: Data, requestBody: SixdigitAuth) {
        var request = URLRequest(url: URL(string: "https://api-passer.herokuapp.com/sixdigit")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonToUpload
                
        ///Timeout settings
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(10)
        let session = URLSession(configuration: configuration)
        
        let task = session.uploadTask(with: request, from: jsonToUpload, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
                self.processServerResult(response: nil)
                return
            }
            
            let response = response as? HTTPURLResponse
            
            if !(200...299).contains(response?.statusCode ?? 404) {
                self.processServerResult(response: nil)
                print("server error")
                return
            }
            
            ///Success
            if data != nil {
                self.processServerResult(response: data)
                print(String(data: data!, encoding: .utf8)!)
            }
        })
        task.resume()
    }
    
    
    func postToServer(sessionID: Data) {
        var request = URLRequest(url: URL(string: "https://api-passer.herokuapp.com/qr")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sessionID
                
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
    
    func processServerResult(response: Data?) {
        ///Switch to the main thread
        DispatchQueue.main.async {
            guard response != nil else {
                self.serverDown = true
                return
            }
            
            self.serverDown = false
            self.response = String(data: response!, encoding: .utf8)!
            
            self.timestamp = Date()
        }
    }
    
}
