//
//  AlviereCaptureCheck.swift
//  HelloCordova
//
//  Created by Luis Bouça on 31/05/2022.
//

import Foundation
import AlCore
import Payments
import AccountsSDK
import AVFoundation
import UIKit

@objc(AlviereCaptureCheck) class AlviereCaptureCheck: CDVPlugin{
    var callbackId: String!
    var delegate:CaptureCheckDelegate!

    override func pluginInitialize() {
        if !AlCoreSDK.shared.setEnvironment(.sandbox) {
            print("Error initializing SDK.")
        }
        delegate = CaptureCheckDelegate()
        return
    }

    @objc(setCheckCallbacks:)func setCheckCallbacks(command: CDVInvokedUrlCommand) {
        delegate.setCheckCallbacks(callbackid: command.callbackId,command: commandDelegate)
    }

    @objc(setDosierCallbacks:)func setDosierCallbacks(command: CDVInvokedUrlCommand) {
        delegate.setDosierCallbacks(callbackid: command.callbackId,command: commandDelegate)
    }

    @objc(captureDosier:)func captureDosier(command: CDVInvokedUrlCommand) {
        let docsJSON = command.argument(at:0) as! String;
        let docsString = try JSONSerialization.jsonObject(with: docsJSON.data(using: .utf8, allowLossyConversion: false)!, options: .mutableContainers) as! Array<String>
        if(docsString == nil || docsString.count == 0){
            commandDelegate.send(CDVPluginResult(status: .error, messageAs: "documents have not been specified!"), callbackId: command.callbackId)
            return;
        }
        
        var docs = Array<Document>()
        
        for doc in docsString {
            docs.append(Document(typeString:doc))
        }
        
        let viewController = AlAccounts.shared.createAccountDossierViewController(data: docs,delegate: delegate, style: AccountDossierStyle.getDefaultStyle())
        
        self.viewController.navigationController?.show(viewController, sender: self)
    }

    @objc(captureCheck:)func captureCheck(command: CDVInvokedUrlCommand) {
        let viewController = AlPayments.shared.createCaptureCheckDepositViewController(delegate: delegate, style: DepositCheckStyle.getDefaultStyle())
        
        self.viewController.navigationController?.show(viewController, sender: self)
    }
    
    @objc(checkPermission:)func checkPermission(command: CDVInvokedUrlCommand) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            commandDelegate.send(CDVPluginResult(status: .ok, messageAs: true), callbackId: command.callbackId)
        } else {
            commandDelegate.send(CDVPluginResult(status: .ok, messageAs: false), callbackId: command.callbackId)
        }
    }
    
    @objc(requestPermission:)func requestPermission(command: CDVInvokedUrlCommand) {
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
}
