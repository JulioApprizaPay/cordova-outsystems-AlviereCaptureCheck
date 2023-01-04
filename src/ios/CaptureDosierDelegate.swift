//
//  CaptureCheckDelegate.swift
//  HelloCordova
//
//  Created by Luis Bouça on 31/05/2022.
//

import Foundation
import AlCore
import AccountsSDK

class CaptureDosierDelegate: NSObject, AccountDossiersCaptureDelegate,AccountsDelegate {
    func didListDossiers(_ dossiers: [AccountDossier]) {
        
    }
    
    var dosierCallbackId: String!
    var command:CDVCommandDelegate!

    func setDosierCallbacks(callbackid: String,command: CDVCommandDelegate) {
        self.dosierCallbackId = callbackid
        self.command = command
    }


    func didHandleEvent(_ event: String, metadata: [String: String]?) {
        if command == nil {
            return;
        }
        command.send(CDVPluginResult(status: CDVCommandStatus.error, messageAs: event), callbackId: dosierCallbackId)

        print("Received event: \(event)\nmetadata: \(metadata ?? [:])")
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
        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: docs), callbackId: dosierCallbackId)
        print("Images Captured!")
    }

}
