//
//  ConfigureSheetController.swift
//  screeNfo
//
//  Created by Ayra Obazee on 10/03/2017.
//  Copyright © 2017 sourcepad. All rights reserved.
//

import Cocoa

class ConfigureSheetController : NSObject {
    
    var defaultsManager = DefaultsManager()

    @IBOutlet var window: NSWindow?
    @IBOutlet weak var tokenTextField: NSTextField!
    
    override init() {
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
        window?.styleMask = NSTitledWindowMask
        tokenTextField.becomeFirstResponder()
        tokenTextField.isEditable = true
    }

    @IBAction func closeConfigureSheet(_ sender: AnyObject) {
        print(tokenTextField.stringValue)
        NSApp.endSheet(window!)
    }

}
