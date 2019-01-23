//
//  Enums.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
enum OperationResultTypes {
    case Success
    case Failed
    case LogicError
}

enum APIResponseTypes: Int {
    case Ok = 200
    case Created = 201
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case RequestTimeout = 408
    case Conflict = 409
    case InternalServerError = 500
    case ServiceUnavailable = 503
    case Undefined = 999
}

enum Environments: UInt8 {
    case Local = 0
    case Test = 1
    case Dev = 2
    case Live = 3
}
