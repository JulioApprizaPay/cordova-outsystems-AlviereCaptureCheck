//
//  CaptureCheckDelegate.swift
//  HelloCordova
//
//  Created by Luis Bouça on 31/05/2022.
//

import Foundation
import AlCore
import Payments
import AccountsSDK

class CaptureCheckDelegate: NSObject, CheckDepositsDelegate, CheckDepositsCaptureDelegate {
    var callbackId: String!
    var command:CDVCommandDelegate!

    func setCallbacks(callbackid: String,command: CDVCommandDelegate) {
        self.callbackId = callbackid
        self.command = command
    }


    func didHandleEvent(_ event: String, metadata: [String: String]?) {
        if command == nil {
            return;
        }
        command.send(CDVPluginResult(status: CDVCommandStatus.error, messageAs: event), callbackId: callbackId)

        print("Received event: \(event)\nmetadata: \(metadata ?? [:])")
    }

    func didCaptureCheck(frontImage: String, backImage: String) {
        if command == nil {
            return;
        }
        let images: [String] = [frontImage, backImage]
        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: images), callbackId: callbackId)
        print("Images Captured!")
    }
}
