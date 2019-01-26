//
//  Constants.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 25.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation

struct Constants {
    
    //The API's base URL
    static let baseUrl = "https://api.etherscan.io"
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let address = "address"
        static let module = "module"
        static let action = "action"
        static let apiKey = "apiKey"
        static let startBlock = "startblock"
        static let endBlock = "endblock"
        static let sort = "sort"
    }
    
//    https://api.etherscan.io/api?
//    module=account&
//    action=txlist
//    &address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a
//    &startblock=0
//    &endblock=99999999
//    &sort=asc
//    &apikey=YQEYE9A52M2IKUNTW2EKFV3TXAT5512DPK
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
    static let APIKey: String = "YQEYE9A52M2IKUNTW2EKFV3TXAT5512DPK"
}
