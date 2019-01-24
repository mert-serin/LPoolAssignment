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
    static let baseUrl = "http://api.etherscan.io"
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let txHash = "txHash"
        static let module = "module"
        static let action = "getstatus"
        static let apiKey = "apiKey"
    }
    
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
