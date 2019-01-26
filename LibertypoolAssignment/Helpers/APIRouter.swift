//
//  APIRouter.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 25.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case getTransaction(address: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getTransaction:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
        case .getTransaction:
            return "/api"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
        case .getTransaction(let address):
            //A dictionary of the key (From the constants file) and its value is returned
            return [
                Constants.Parameters.address : address,
                Constants.Parameters.action : "txlist",
                Constants.Parameters.module : "account",
                Constants.Parameters.apiKey : Constants.APIKey,
                Constants.Parameters.endBlock : 99999999,
                Constants.Parameters.startBlock : 0,
                Constants.Parameters.sort : "desc"
            ]
        }
    }
}
