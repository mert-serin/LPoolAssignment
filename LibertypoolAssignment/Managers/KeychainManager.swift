//
//  KeychainManager.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 28.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager{
    
    func saveUser(model:UserModel) -> Bool{
        
        var saved: [Bool] = []
        //save current user details
        saved.append(KeychainWrapper.standard.set(model.walletAddress, forKey: KeychainManagerKeys.walletAddressKey))
        saved.append(KeychainWrapper.standard.set(model.walletName, forKey: KeychainManagerKeys.walletNameKey))
        
        return !saved.contains(false)
    }
    
    
    func getUser() -> UserModel?{
        if let walletAddress = KeychainWrapper.standard.string(forKey: KeychainManagerKeys.walletAddressKey),let walletName = KeychainWrapper.standard.string(forKey: KeychainManagerKeys.walletNameKey){
            return UserModel(walletName: walletName, walletAddress: walletAddress)
        }        
        return nil
    }
    
}

class KeychainManagerKeys{
    
    static let walletNameKey = "walletName"
    static let walletAddressKey = "walletAddress"

}
