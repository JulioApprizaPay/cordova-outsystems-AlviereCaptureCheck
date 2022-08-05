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

    @objc(setCallbacks:)func setCallbacks(command: CDVInvokedUrlCommand) {
        delegate.setCallbacks(callbackid: command.callbackId,command: commandDelegate)
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
