//
//  Enums.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

enum TransferDirection{
    case In
    case Out
}
