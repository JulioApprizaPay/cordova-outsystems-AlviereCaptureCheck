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

class CaptureCheckDelegate: NSObject, CheckDepositsDelegate, CheckDepositsCaptureDelegate, AccountDossiersCaptureDelegate,AccountDossiersSuccessDelegate {
    func didListDossiers(_ dossiers: [AccountDossier]) {
        
    }
    
    var dosierCallbackId: String!
    var checkCallbackId: String!
    var command:CDVCommandDelegate!

    func setCheckCallbacks(callbackid: String,command: CDVCommandDelegate) {
        self.checkCallbackId = callbackid
        self.command = command
    }

    func setDosierCallbacks(callbackid: String,command: CDVCommandDelegate) {
        self.dosierCallbackId = callbackid
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
    func didCaptureDocuments(_ documents: [Document]) {
        if command == nil {
            return;
        }
        var docs: Array<Dictionary<String,String>> = Array<Dictionary<String,String>>()
        for doc in documents {
            var docJSON:Dictionary<String,String> = Dictionary<String,String>()
            docJSON["image"] = doc.file
            docJSON["type"] = doc.type!.rawValue
            docs.append(docJSON)
        }
        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: docs), callbackId: checkCallbackId)
        print("Images Captured!")
    }

}
