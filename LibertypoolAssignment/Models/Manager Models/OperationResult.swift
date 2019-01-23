//
//  OperationResult.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
class OperationResult: NSObject {
    
    var message: String = ""
    var object: Any?
    var type: OperationResultTypes!
    var isSuccess: Bool { return type == OperationResultTypes.Success }
    var isApiResponseSuccess: Bool { return apiResponseType == .Ok || apiResponseType == .Created }
    var apiResponseType: APIResponseTypes = .Undefined
    var shouldLogout:Bool { return apiResponseType == .Forbidden || apiResponseType == .Unauthorized}
    
    override init() {
        super.init()
    }
    
}
