//
//  AlviereCaptureCheck.swift
//  HelloCordova
//
//  Created by Luis Bouça on 31/05/2022.
//  Refactored by André Grillo on 23/01/2023

import Foundation
import AlCore
import Payments
import AccountsSDK
import AVFoundation
import UIKit

@objc(AlviereCaptureCheck)
class AlviereCaptureCheck: CDVPlugin, AccountDossiersCaptureDelegate, CheckDepositsCaptureDelegate {
    var closeAction: (() -> Void)?
    var pluginCallback = PluginCallback()
    
    override func pluginInitialize() {
        pluginCallback = PluginCallback()
        print("⭐️ \(pluginCallback)")
    }
        
    @objc(hideNavigationBar:)
    func hideNavigationBar(command: CDVInvokedUrlCommand){
        if (self.viewController.navigationController != nil){
            self.viewController.navigationController!.isNavigationBarHidden = true
        }
        self.commandDelegate.send(CDVPluginResult(status:.ok), callbackId: command.callbackId);
    }

    @objc(setCheckCallbacks:)
    func setCheckCallbacks(command: CDVInvokedUrlCommand) {
        pluginCallback.resetCallbacks()
        pluginCallback.checkCallbackID = command.callbackId
    }

    @objc(setDossierCallbacks:)
    func setDossierCallbacks(command: CDVInvokedUrlCommand) {
        
        pluginCallback.resetCallbacks()
        pluginCallback.dossierCallbackID = command.callbackId
    }

    @objc(captureDossier:)
    func captureDossier(command: CDVInvokedUrlCommand) {
//        print("⭐️ \(command.arguments)")
//        for argument in command.arguments {
//            print("⭐️ \(argument)")
//        }

        var documents: Array<String> = []
        let arguments = command.arguments[0] as! Array<String>
        for argument in arguments {
            documents.append(argument)
        }
        let jsonData = try! JSONEncoder().encode(documents)
        let docsJSON = String(data: jsonData, encoding: .utf8)
        
//        let docsJSON = "[\"DRIVER_LICENSE_FRONT\", \"DRIVER_LICENSE_BACK\", \"SELFIE\"]"
//        let docsJSON = command.argument(at:0) as! String;
//        let docsJSON = command.arguments[0] as! String;
        let docsString = try? JSONSerialization.jsonObject(with: docsJSON!.data(using: .utf8, allowLossyConversion: false)!, options: .mutableContainers) as? Array<String>
        if(docsString == nil || docsString!.count == 0){
            sendPluginResult(status: CDVCommandStatus_ERROR, message: "Documents have not been specified!", callbackType: .dossier)
            //commandDelegate.send(CDVPluginResult(status: .error, messageAs: "Documents have not been specified!"), callbackId: command.callbackId)
            return;
        }
        var docs = Array<Document>()
        for doc in docsString! {
            docs.append(Document(typeString:doc))
        }

        let viewController = AlAccounts.shared.createCaptureAccountDossierViewController(data: docs,delegate: self, style: AccountDossierStyle.getDefaultStyle())
        let close = (viewController.view.subviews.first { $0 is UINavigationBar } as? UINavigationBar)?.topItem?.rightBarButtonItem
        self.closeAction = {
            viewController.dismiss()
            self.sendPluginResult(status: CDVCommandStatus_ERROR, message: "User cancalled", callbackType: .dossier)
        }
        close?.target = self
        close?.action = #selector(self.closeOnClick)
        
        self.viewController.navigationController?.show(viewController, sender: self)
    }
    
    @objc
    func closeOnClick() {
        self.closeAction?()
    }

    @objc(captureCheck:)
    func captureCheck(command: CDVInvokedUrlCommand) {
        let viewController = AlPayments.shared.createCaptureCheckDepositViewController(delegate: self, style: DepositCheckStyle.getDefaultStyle())
        
        self.viewController.navigationController?.show(viewController, sender: self)
    }
    
    @objc(checkPermission:)
    func checkPermission(command: CDVInvokedUrlCommand) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            sendPluginResult(status: CDVCommandStatus_OK, message: "ok", callbackType: .check)
            //commandDelegate.send(CDVPluginResult(status: .ok, messageAs: true), callbackId: command.callbackId)
        } else {
            sendPluginResult(status: CDVCommandStatus_ERROR, message: "false", callbackType: .check)
            //commandDelegate.send(CDVPluginResult(status: .ok, messageAs: false), callbackId: command.callbackId)
        }
    }
    
    @objc(requestPermission:)
    func requestPermission(command: CDVInvokedUrlCommand) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            commandDelegate.send(CDVPluginResult(status: .ok, messageAs: true), callbackId: command.callbackId)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
               if granted == true {
                   self.commandDelegate.send(CDVPluginResult(status: .ok, messageAs: true), callbackId: command.callbackId)
               } else {
                   self.commandDelegate.send(CDVPluginResult(status: .ok, messageAs: false), callbackId: command.callbackId)
               }
           })
        }
    }
    
    func didHandleEvent(_ event: String, metadata: [String: String]?) {
        print("⭐️ Received event: \(event)\nmetadata: \(metadata ?? [:])")
//            command.send(CDVPluginResult(status: CDVCommandStatus.error, messageAs: event), callbackId: dosierCallbackId)
        if pluginCallback.checkCallbackID != nil {
            sendPluginResult(status: CDVCommandStatus_ERROR, message: event, callbackType: .check)
        } else if pluginCallback.dossierCallbackID != nil {
            sendPluginResult(status: CDVCommandStatus_ERROR, message: event, callbackType: .dossier)
        }
    }
    
//    //MARK: AccountDossiersCaptureDelegate
    func setDossierCallbacks(callbackid: String,command: CDVCommandDelegate) {
        print("⭐️ setDosierCallbacks")
//        pluginCallback.resetCallbacks()
//        pluginCallback.dossierCallbackID = command
//        self.dosierCallbackId = callbackid
//        self.command = command
    }
    
    func didCaptureDocuments(_ documents: [Document]) {
        print("⭐️ Images Captured!")
        var docs: Array<Dictionary<String,String>> = Array<Dictionary<String,String>>()
        for doc in documents {
            var docJSON:Dictionary<String,String> = Dictionary<String,String>()
            docJSON["image"] = doc.file
            docJSON["type"] = doc.type!.rawValue
            docs.append(docJSON)
        }
//        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: docs), callbackId: dosierCallbackId)
        if let data = try? JSONSerialization.data(withJSONObject: docs, options: .prettyPrinted) {
            if let docsJson = String(data: data, encoding: String.Encoding.utf8) {
                //        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: images), callbackId: checkCallbackId)
                sendPluginResult(status: CDVCommandStatus_OK, message: docsJson, callbackType: .dossier)
            } else {
                sendPluginResult(status: CDVCommandStatus_ERROR, message: "Error: Could not create the json object from data", callbackType: .dossier)
            }
        } else {
            sendPluginResult(status: CDVCommandStatus_ERROR, message: "Error: Could not serialize docs Array to json", callbackType: .dossier)
        }
    }
    
    
    //MARK: CheckDepositsCaptureDelegate
    func didCaptureCheck(frontImage: String, backImage: String) {
        let images: [String] = [frontImage, backImage]
        if let data = try? JSONSerialization.data(withJSONObject: images, options: .prettyPrinted) {
            if let imagesJson = String(data: data, encoding: String.Encoding.utf8) {
                //        command.send(CDVPluginResult(status: CDVCommandStatus.ok, messageAs: images), callbackId: checkCallbackId)
                print("⭐️ Images Captured!")
                sendPluginResult(status: CDVCommandStatus_OK, message: imagesJson, callbackType: .check)
            } else {
                sendPluginResult(status: CDVCommandStatus_ERROR, message: "Error: Could not create the json object from data", callbackType: .check)
            }
        } else {
            sendPluginResult(status: CDVCommandStatus_ERROR, message: "Error: Could not serialize images Array to json", callbackType: .check)
        }
    }
    
    func sendPluginResult(status: CDVCommandStatus, message: String, callbackType: CallbackType) {
        var pluginResult = CDVPluginResult(status: status, messageAs: message)
        if callbackType == .dossier {
            if (pluginCallback.dossierCallbackID) != nil {
                self.commandDelegate!.send(pluginResult, callbackId: pluginCallback.dossierCallbackID)
            }
        } else {
            if (pluginCallback.checkCallbackID) != nil {
                self.commandDelegate!.send(pluginResult, callbackId: pluginCallback.checkCallbackID)
            }
        }
    }
}

class PluginCallback {
    var dossierCallbackID: String?
    var checkCallbackID: String?
    
    func resetCallbacks(){
        self.dossierCallbackID = nil
        self.checkCallbackID = nil
    }
}

enum CallbackType {
    case check
    case dossier
}

