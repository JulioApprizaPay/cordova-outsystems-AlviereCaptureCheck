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
        
        self.viewController.present(viewController, animated: false)
        //self.viewController.navigationController?.show(viewController, sender: self)
    }
}
