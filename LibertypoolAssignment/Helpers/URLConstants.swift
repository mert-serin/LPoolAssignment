//
//  URLConstants.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
class URLConstants {
    
    // TODO: NEVER FORGET TO MODIFY HERE! (do NOT remove this comment line ever!)
    internal static let environment: Environments = Environments.Dev
    
    private static let _server = URLConstants.getURL()
    private static let _endPoint = "\(_server)"
    
    static let getTransactionsURL = "\(_endPoint)/api&apikey=\(APIKey)"
    
    private static func getURL() -> String {
        
        switch environment {
        case .Local:
            return ""
            
        case .Dev:
            return ""
            
        case .Test:
            return ""
            
        case .Live:
            return "http://api.etherscan.io"
        }
    }
    
    private static var APIKey: String = "YQEYE9A52M2IKUNTW2EKFV3TXAT5512DPK"
    
}
