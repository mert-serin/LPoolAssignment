//
//  UserModel.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 28.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
import RxSwift
class UserModel{
    var walletName = ""
    var walletAddress = ""
    
    convenience init(walletName : String, walletAddress : String) {
        self.init()
        self.walletName = walletName
        self.walletAddress = walletAddress
    }
}

class UserRepository {
    static func getUser() -> Single<UserModel> {
        return Single.create { single in
            let login = KeychainManager().getUser()!
            single(.success(login))
            return Disposables.create {
                // single disposed
            }
        }
    }
}
