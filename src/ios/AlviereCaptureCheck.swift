//
//  BeneficiaryDelegate.swift
//  HelloCordova
//
//  Created by Luis Bouça on 31/05/2022.
//

import Foundation
import AlCore
import Payments

@objc(AlviereCaptureCheck) class AlviereCaptureCheck: CDVPlugin,CheckDepositsDelegate,CheckDepositsCaptureDelegate {
    
    var callbackId:String!

    func init(){
        if !AlCoreSDK.shared.setEnvironment(.sandbox) {
            print("Error initializing SDK.")
        }
        return true
    }

    @objc(captureCheck)func captureCheck(command:CDVInvokedUrlCommand){
        callbackId = command.callbackId;
    }

    @objc(captureCheck)func captureCheck(command:CDVInvokedUrlCommand){
        let viewController = AlAccounts.shared.createCaptureCheckDepositViewController(delegate: self, style: style)
        self.navigationController?.show(viewController, sender: self)
    }
    func didHandleEvent(_ event: String, metadata: [String : String]?) {
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus.error,messageAs:event), callbackId: callbackId)
        
        print("Received event: \(event)\nmetadata: \(metadata ?? [:])")
    }
    func didCaptureCheck(frontImage: String, backImage: String) {
        var images:[String] = [frontImage,backImage]
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus.ok,messageAs:images), callbackId: callbackId)
        print("Images Captured!")
    }
}
