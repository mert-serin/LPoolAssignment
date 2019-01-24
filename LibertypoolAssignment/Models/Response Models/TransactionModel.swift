//
//  TransactionModel.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 25.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
struct TransactionModel: Codable {
    let from:String
    let to:String
    let value:Double
    let timestamp:String
    var date:Date?{
        get{
            return Date(timeIntervalSince1970: Double(timestamp)!)
        }
    }
}
