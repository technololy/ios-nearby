//
//  NearByStandAloneClass.swift
//  NearbyMessagesExampleSwift
//
//  Created by Ololade Oyebanji on 18/12/2020.
//  Copyright © 2020 Google. All rights reserved.
//

import Foundation

public class NearByImplemtation{
    
    var MyAPIKey: String?
    let MyAPIKey2 = "AIzaSyDT4JFOoK5WAIdbl3cKBBnfRhrmxZsD-H8"
    /**
    * @property
    * This class lets you check the permission state of Nearby for the app on the current device.  If
    * the user has not opted into Nearby, publications and subscriptions will not function.
    */
    var nearbyPermission: GNSPermission!

    /**
    * @property
    * The message manager lets you create publications and subscriptions.  They are valid only as long
    * as the manager exists.
    */
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    
    init(MyAPIKey:String ){
       print("initializing the class")
        SetApiKey();
        if !GNSPermission.isGranted() {
            toggleNearbyPermission()
        }
        
        
        // Enable debug logging to help track down problems.
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        
        // Create the message manager, which lets you publish messages and subscribe to messages
        // published by nearby devices.
        messageMgr = GNSMessageManager(apiKey: kMyAPIKey,
          paramsBlock: {(params: GNSMessageManagerParams?) -> Void in
            guard let params = params else { return }

            // This is called when microphone permission is enabled or disabled by the user.
            params.microphonePermissionErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if microphone use is allowed")
              }
            }
            // This is called when Bluetooth permission is enabled or disabled by the user.
            params.bluetoothPermissionErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if Bluetooth use is allowed")
              }
            }
            // This is called when Bluetooth is powered on or off by the user.
            params.bluetoothPowerErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if Bluetooth is turned on")
              }
            }
        })
    
    }
    /// Toggles the permission state of Nearby.
      @objc func toggleNearbyPermission() {
      GNSPermission.setGranted(!GNSPermission.isGranted())
    }
    
    
    /// sets the api key.
    @objc public func SetApiKey()-> Void {
        MyAPIKey = "AIzaSyDT4JFOoK5WAIdbl3cKBBnfRhrmxZsD-H8";
    }
    
    @objc public func StartSharing(withName name: String)->Void{
        if let messageMgr = self.messageMgr {
          // Show the name in the message view title and set up the Stop button.
      

          // Publish the name to nearby devices.
          let pubMessage: GNSMessage = GNSMessage(content: name.data(using: .utf8,
            allowLossyConversion: true))
          publication = messageMgr.publication(with: pubMessage)

          // Subscribe to messages from nearby devices and display them in the message view.
          subscription = messageMgr.subscription(messageFoundHandler: {[unowned self] (message: GNSMessage?) -> Void in
            guard let message = message else { return }
            print(String(data: message.content, encoding:.utf8) ?? "nothing")
            
          }, messageLostHandler: {[unowned self](message: GNSMessage?) -> Void in
            guard let message = message else { return }
            print(String(data: message.content, encoding: .utf8) ?? "nothing")
          })
        }
      }
    
    
    
}
