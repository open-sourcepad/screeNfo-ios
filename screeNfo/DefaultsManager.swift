//
//  DefaultsManager.swift
//  screeNfo
//
//  Created by Ayra Obazee on 10/03/2017.
//  Copyright © 2017 sourcepad. All rights reserved.
//


import ScreenSaver

class DefaultsManager {
    
    var defaults: UserDefaults
    
    init() {
        let identifier = Bundle(for: DefaultsManager.self).bundleIdentifier
        defaults = ScreenSaverDefaults(forModuleWithName: identifier!)! as UserDefaults
    }
    
    var userToken: String {
        set(userToken) {
            setUserToken(userToken, key: "DefaultsUserToken")
        }
        get {
            return getUserToken("DefaultsUserToken") ?? ""
        }
    }
    
    func setUserToken(_ token: String, key: String) {
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: token), forKey: key)
        defaults.synchronize()
    }
    
    func getUserToken(_ key: String) -> String? {
        if let userTokenData = defaults.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: userTokenData as Data) as? String
        }
        return nil;
    }
    
}
