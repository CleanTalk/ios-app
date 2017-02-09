//
//  AbstractRequest.swift
//  HelpAround
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public class AbstractRequest<T : Mappable> {
    
    public typealias ResponseType = T
    public var serverURL : String
    public var encodingType: ParameterEncoding = URLEncoding.httpBody
    
    public init () {
        serverURL = Constants.URL.apiURL
    }
    
    func urlString() -> String {
        preconditionFailure("Override this in subclasses")
    }
    
    func urlParameters() -> [String : String]? {
        return nil
    }
    
    func parameters() -> [String : Any]? {
        return nil
    }
    
    public func fullUrlString() -> String {
        var fullUrlString : String = urlString()
        if let urlParameters = urlParameters() {
            var parametersArray : [String] = [String]()
            for (key, value) in urlParameters {
                parametersArray.append(key + "=" + value)
            }
            
            let parametersString = parametersArray.joined(separator: "&")
            
            fullUrlString = fullUrlString + "?" + parametersString
        }
        
        return fullUrlString
    }
    
    public func method() -> RequestMethod {
        preconditionFailure("Override this in subclasses")
    }
    
    public func headers() -> [String: String]? {
        return ["Content-Type" : "application/json", "Accept" : "application/json"]
    }
    
    
    public func response(object: [String : AnyObject]) -> ResponseType? {
        return Mapper<ResponseType>().map(JSONObject: object)
    }
    
    public func response(object: [[String : Any]]) -> [ResponseType]? {
        return Mapper<ResponseType>().mapArray(JSONArray: object)
    }
    
}
