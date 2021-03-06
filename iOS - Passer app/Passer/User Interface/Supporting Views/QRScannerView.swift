//
//  QRScannerView.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 19/05/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI
import CodeScanner
///UIKit provides spinner graphics
import UIKit

struct QRAuth: Codable {
    let sessionID: String
    let passwordItems: [PasswordItem]?
    let bankCardItems: [BankCardItem]?
    let otherItems: [OtherItem]?
}

struct QRScannerView: View {
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var show = false
    @State private var spinner = true
    
    let chosenPasswords: [PasswordItem]
    let chosenBankCards: [BankCardItem]
    let chosenOthers: [OtherItem]
    
    var body: some View {
        VStack {
            if show {
                HStack {
                    Text("Tap to go back").font(.footnote)
                    Image(systemName: "arrow.up")
                }.padding(.bottom, 50)
                Text("Visit website https://passer.netlify.app on another device")
                Text("and scan the QR code to access selected items.")
                CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                    .frame(width: 350, height: 300)
                    .padding(.bottom)
            }
            else {
                ProgressView()
                    .padding(.bottom, 50)
            }
        }.padding()
        ///Shows everything in this view after one tick (one second)
        ///Reason - performance issues when launching the animation and this view at once (laggy graphics)
        ///With this solution, the animation can perform smoothly and the corresponding view will be visible right after
        .onReceive(timer) { _ in
            self.show = true
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let dataFromQR):
            ///Send data to server only if QR code scan succeeded
            let qr = QRAuth(sessionID: dataFromQR, passwordItems: self.chosenPasswords, bankCardItems: self.chosenBankCards, otherItems: self.chosenOthers)
            guard let json = try? JSONEncoder().encode(qr) else {
                return
            }
            let server = ServerDelegate()
            server.postToServer(sessionID: json)
            
        case .failure(let error):
            print("Scanning failed.", error)
        }
    }
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView(chosenPasswords: [PasswordItem](), chosenBankCards: [BankCardItem](), chosenOthers: [OtherItem]())
    }
}
