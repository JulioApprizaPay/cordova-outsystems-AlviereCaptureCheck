//
//  CaptureCheckDelegate.swift
//  HelloCordova
//
//  Created by Luis Bouça on 31/05/2022.
//

import Foundation
import AlCore
import Payments

class CaptureCheckDelegate: NSObject, CheckDepositsDelegate, CheckDepositsCaptureDelegate {


    var checkCallbackId: String!
    var command:CDVCommandDelegate!

    func setCheckCallbacks(callbackid: String,command: CDVCommandDelegate) {
        self.checkCallbackId = callbackid
        self.command = command
    }

    func didHandleEvent(_ event: String, metadata: [String: String]?) {
        if command == nil {
            return;
        }
        command.send(CDVPluginResult(status: CDVCommandStatus.error, messageAs: event), callbackId: checkCallbackId)

        print("Received event: \(event)\nmetadata: \(metadata ?? [:])")
    }

    func didCaptureCheck(frontImage: String, backImage: String) {
        if command == nil {
            return;
        }
        let images: [String] = [frontImage, backImage]
        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: images), callbackId: checkCallbackId)
        print("Images Captured!")
    }

}
