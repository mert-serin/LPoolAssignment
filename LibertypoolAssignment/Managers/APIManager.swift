//
//  APIManager.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
import Alamofire

typealias APIResponse = (OperationResult) -> Void

class APIManager: NSObject {
    
    private static var unauthorizedMessageShown = false
    var alamofireManager = Alamofire.SessionManager.default
    
    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 // seconds
        configuration.timeoutIntervalForResource = 60
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    init(timeout: TimeInterval) {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout // seconds
        configuration.timeoutIntervalForResource = timeout
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func makeRequest(method:String, path: String, parameters: Parameters?, encoding:ParameterEncoding = URLEncoding.default, headers:HTTPHeaders?, onCompletion:@escaping APIResponse){
        // Internet connection check.
        if Reachability.isConnectedToNetwork() == false {
            let result = OperationResult()
            result.type = .LogicError
            result.message = "Please make sure you have an active internet connection."
            onCompletion(result)
            return
        }
        
        Alamofire.request(path,
                          method:HTTPMethod(rawValue: method)!,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers:headers).responseJSON { response in
                            self.processAPIResponse(response: response.response, data: response.result.value, error: response.error, onCompletion: onCompletion)
        }
        
        
    }
    
//    private func unauthorizedResponse(path: String, parameters: [String: AnyObject], onCompletion: APIResponse, isPost: Bool) {
//        // TODO: GET NEW TOKEN AND RECALL REQUEST. Maybe not? Definitely not required now.
//
//        print("unauthorized response!")
//
//        let operationResult = OperationResult()
//        operationResult.type = .LogicError
//        operationResult.message = "Unauthorized!"
//        onCompletion(operationResult)
//    }
    
    private func processAPIResponse(response: HTTPURLResponse?, data: Any?, error: Error?, onCompletion: APIResponse) {
        // Operation result.
        let operationResult = OperationResult()
        
        /*
         print("RESPONSE: \(response)")
         print("ERROR: \(error)")
         */
        
        var serverMessage: String = ""
        do {
            // Get server message.
            let msg = response?.allHeaderFields["ReasonPhrase"] as? String
            serverMessage = msg ?? ""
        }
        
        operationResult.apiResponseType = response?.statusCode.toAPIResponseType() ?? APIResponseTypes.Undefined
        if let error = error {
            if error.localizedDescription == "\(NSURLErrorTimedOut)" {
                operationResult.apiResponseType = APIResponseTypes.RequestTimeout
            }
        }
        
        
        switch operationResult.apiResponseType {
            
        case .Ok:
            
            if let msg = response?.allHeaderFields["ResultPhrase"] as? String {
                serverMessage = msg
            }
            
            operationResult.type = .Success
            operationResult.message = serverMessage.isEmpty ?
                "Operation successful but no message returned (Ok)."
                : serverMessage
            
        case .Created:
            
            if let msg = response?.allHeaderFields["ResultPhrase"] as? String {
                serverMessage = msg
            }
            
            operationResult.type = .Success
            operationResult.message = serverMessage.isEmpty ?
                "Operation successful but no message returned (Created)."
                : serverMessage
            
        case .BadRequest:
            operationResult.type = .LogicError
            operationResult.message = serverMessage.isEmpty ?
                "Bad request."
                : serverMessage
            
        case .NotFound:
            operationResult.type = .LogicError
            operationResult.message = serverMessage.isEmpty ?
                "Server returned 404 (Not Found)."
                : serverMessage
            
        case .Unauthorized:
            operationResult.type = .LogicError
            operationResult.message = serverMessage.isEmpty ?
                "Unauthorized."
                : serverMessage
            // Do not try to get a token again if it's already login.
            // TODO: No need to test or do anything here.
            /*if path != URLConstants.loginUrl {
             self.unauthorizedResponse(path, parameters: parameters, onCompletion: onCompletion, isPost: true)
             
             return
             }*/
            
        case .Conflict:
            operationResult.type = .LogicError
            operationResult.message = serverMessage.isEmpty ?
                "Operation not completed due to data conflict."
                : serverMessage
            
        case .RequestTimeout:
            operationResult.type = .Failed
            operationResult.message = serverMessage.isEmpty ?
                "Request timed out."
                : serverMessage
            
        case .ServiceUnavailable:
            operationResult.type = .Failed
            operationResult.message = serverMessage.isEmpty ?
                "Service unavailable."
                : serverMessage
            
        case .InternalServerError:
            operationResult.type = .Failed
            operationResult.message = serverMessage.isEmpty ?
                "Internal server error."
                : serverMessage
            
        default:
            operationResult.type = .Failed
            operationResult.message = serverMessage.isEmpty ?
                "Unhandled response from the server."
                : serverMessage
            
        }
        
        /*
         print(operationResult.type)
         print(operationResult.apiResponseType)
         print(operationResult.message)
         print(operationResult.object)
         */
        
        
        // ======= EXACTLY SAME CODE, AS EXPECTED =======
        // Get the data of the response.
        operationResult.object = data
        
        
        // Callback
        onCompletion(operationResult)
        
        
    }
}
