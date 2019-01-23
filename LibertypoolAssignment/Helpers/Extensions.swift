//
//  Extensions.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation

extension Int {
    func toAPIResponseType() -> APIResponseTypes {
        if self == 200 {
            return .Ok
        }
        else if self == 201 {
            return .Created
        }
        else if self == 400 {
            return .BadRequest
        }
        else if self == 401 {
            return .Unauthorized
        }
        else if self == 403 {
            return .Forbidden
        }
        else if self == 404 {
            return .NotFound
        }
        else if self == 405 {
            return .MethodNotAllowed
        }
        else if self == 409 {
            return .Conflict
        }
        else if self == 500 {
            return .InternalServerError
        }
        else if self == 503 {
            return .ServiceUnavailable
        }
        else {
            return .Undefined
        }
    }
}
