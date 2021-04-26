//
//  Socket.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 26/04/2021.
//  Copyright © 2021 Peter Čuřík Jr. All rights reserved.
//

import Foundation
import SocketIO
import UIKit

class Socket: ObservableObject {
    @Published var sixDigitCode: String?
    
    let socketManager: SocketManager
    let socketIOClient: SocketIOClient
    let identity: IdentityStruct
    let deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    init(identity: IdentityStruct) {
        self.identity = identity
        self.socketManager = SocketManager(
            socketURL: URL(string: "https://tp-service.herokuapp.com/oidc/account")!,
            config: [
                .log(false),
                .compress,
                .secure(false),
                .connectParams(["deviceId":self.deviceID])
            ]
        )
        
        self.socketIOClient = self.socketManager.defaultSocket
        
        self.socketIOClient.on("refreshRequest") { data, ack in
            print("refreshRequest event summoned. data: ", data)
            
            self.socketIOClient.emitWithAck("refreshReply", self.identity).timingOut(after: 1) { data in
                print("sending callback to server")
                ack.with()
            }
        }
        
        self.socketIOClient.on("code") { data, ack in
            print("code event summoned. data: ", data)
            self.sixDigitCode = (data[0] as! String)
        }
        
        self.socketIOClient.connect()
    }
    
    private func connect() {
        print("connecting...")
        self.socketIOClient.connect()
    }
    
    func login() {
        connect()
        self.socketIOClient.emit("login", self.identity)
    }
    
    func logout() {
        print("emitting logout event")
        self.socketIOClient.emit("logout")
    }
}
