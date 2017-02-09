//
//  AbstractDispatcher.swift
//  HelpAround
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import Foundation
import ObjectMapper

public class AbstractDispatcher {

    required public init() {

    }
    
    final public func run<T : Mappable>(request: AbstractRequest<T>, keyPath: String?, completion: @escaping (Response<T>) -> Void) {
        runRequest(request: request, keyPath: keyPath) { response in
            switch response {
            case .success(let data):
                if let dictionary =  data as? [String : AnyObject] {
                    if let responseObject = request.response(object: dictionary) {
                        completion(Response.success(responseObject))
                        return
                    }
                }
                let error: Error = DispatcherDataError.parseError(data)
                completion(Response.error(error))
            case .error(let error):
                completion(Response.error(error))
            }
        }
    }
    
    final public func run<T : Mappable>(request: AbstractRequest<T>, keyPath: String?, completion: @escaping (Response<[T]>) -> Void) {
        runRequest(request: request, keyPath: keyPath) { response in
            switch response {
            case .success(let data):
                var error: Error
                if keyPath == nil {
                    if let array = data as? [[String : Any]] {
                        if let responseObject = request.response(object: array) {
                            completion(Response.success(responseObject))
                            return
                        }
                    }
                    error = DispatcherDataError.parseError(data)
                } else if let dictionary = data as? [String : Any], let array = dictionary[keyPath!] as? [[String : Any]] {
                    if let responseObject = request.response(object: array) {
                        completion(Response.success(responseObject))
                        return
                    }
                }
                error = DispatcherDataError.parseError(data)
                completion(Response.error(error))
            case .error(let error):
                completion(Response.error(error))
            }
        }
        
    }
    
    public func runRequest<T : Mappable>(request: AbstractRequest<T>, keyPath: String?, completion: @escaping (Response<Any>) -> Void) {
        preconditionFailure("Override in subclass")
    }
    
}
