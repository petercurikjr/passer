//
//  Networking.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 01/04/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import Foundation

func postToServer(uploadData: Data) {
    //print("Sending data: " + String(data: uploadData, encoding: .utf8)!)

    var request = URLRequest(url: URL(string: "http://192.168.1.118:5000/")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = uploadData;

    let task = URLSession.shared.uploadTask(with: request, from: uploadData, completionHandler: { (data, response, error) in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print(dataString)
        }
    })
    task.resume()
}





