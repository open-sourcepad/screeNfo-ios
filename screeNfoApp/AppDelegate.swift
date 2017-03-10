//
//  AppDelegate.swift
//  screeNfoApp
//
//  Created by Ayra Obazee on 10/03/2017.
//  Copyright © 2017 Mulle Kybernetik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    lazy var screenSaverView = ScreenView(frame: NSZeroRect, isPreview: false)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if let screenSaverView = screenSaverView {
            screenSaverView.frame = window.contentView!.bounds
            window.contentView!.addSubview(screenSaverView)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

