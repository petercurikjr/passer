//
//  Networking.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 01/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import SwiftUI

///Classes with "ObservableObject" can be used to initialize @ObservedObject variables in a View
///Those variables are able to update a View according to values of @Published variables in "ObservableObject" class
///This can be achieved also with publishers in Combine framework, but SwiftUI offers a super-easy approch to this problem (which, of course means less control and features of observing, but this is sufficient for our purposes)
final class ServerDelegate: ObservableObject {
    
    ///These variables can update the view
    @Published var sixdigitData: SixdigitAuth?
    @Published var serverDown: Bool = false
    
    private var sixdigitStructure: SixdigitAuth
    
    init() {
        self.sixdigitStructure = generateStruct()
        let toJSON = sixdigitJSON(input: self.sixdigitStructure)
        postToServer(jsonToUpload: toJSON!, swiftStructure: self.sixdigitStructure)
    }
    
    func reload() {
        self.sixdigitStructure = generateStruct()
        let toJSON = sixdigitJSON(input: self.sixdigitStructure)
        postToServer(jsonToUpload: toJSON!, swiftStructure: self.sixdigitStructure)
    }
    
    func postToServer(jsonToUpload: Data, swiftStructure: SixdigitAuth) {
        var request = URLRequest(url: URL(string: "http://192.168.1.118:5000/")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonToUpload;
        
        ///timeout settings
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(10)
        let session = URLSession(configuration: configuration)
        
        let task = session.uploadTask(with: request, from: jsonToUpload, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                print("error: \(error)")
                self.processServerResult(swiftStructure: nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                self.processServerResult(swiftStructure: nil)
                print("server error")
                return
            }
            
            ///success
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                self.processServerResult(swiftStructure: swiftStructure)
                print(dataString)
            }
        })
        task.resume()
    }
    
    func processServerResult(swiftStructure: SixdigitAuth?) {
        ///switch to main thread
        DispatchQueue.main.async {
            guard swiftStructure != nil else {
                self.serverDown = true
                return
            }
            
            self.serverDown = false
            self.sixdigitData = swiftStructure
            print(self.sixdigitStructure.sixdigitCode!)
            print(self.sixdigitStructure.timestamp!)
            print((self.sixdigitData?.sixdigitCode)!)
            print((self.sixdigitData?.timestamp)!)
        }
    }
    
}






