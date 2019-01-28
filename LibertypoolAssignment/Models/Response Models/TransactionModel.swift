//
//  TransactionModel.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 25.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
import RxSwift
struct TransactionResponseModel:Codable{
    let status:String
    let message:String
    let result:[TransactionModel]
}

struct TransactionModel: Codable {
    let from:String
    let to:String
    let value:String
    let timeStamp:String
    var date:Date?{
        get{
            return Date(timeIntervalSince1970: Double(timeStamp)!)
        }
    }
    var direction:Bool{
        get{
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                return to == appDelegate.wallet.value.walletAddress
            }
            return false
        }
    }
}
