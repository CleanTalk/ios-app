//
//  File.swift
//  RequestDispatcher
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class AlamofireDispatcher: AbstractDispatcher {

    static let shared = AlamofireDispatcher()
    
    required public init() {
        super.init()
    }
    
    override func runRequest<T : Mappable>(request: AbstractRequest<T>, keyPath: String?, completion: @escaping (Response<Any>) -> Void) {
        Alamofire.request(request.serverURL + request.fullUrlString(), method: HTTPMethod(rawValue: request.method().rawValue)!, parameters: request.parameters(), encoding: request.encodingType, headers: request.headers()).responseJSON { response in
            switch response.result {
            case .success(let data):
                completion(Response.success(data))
            case .failure(let error):
                completion(Response.error(error))
            }
        }
    }
}
