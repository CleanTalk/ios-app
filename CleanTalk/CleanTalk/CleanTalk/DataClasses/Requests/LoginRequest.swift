//
//  LoginRequest.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

class LoginRequest: AbstractRequest<LoginModel> {
    public var login: String?
    public var password: String?
    public var deviceToken: String?
    
    override func urlString() -> String {
        return "my/session?app_mode=1"
    }
    
    override func parameters() -> [String : Any]? {
        let parameters = [
            "login": login ?? "",
            "password": password ?? "",
            "app_device_token": deviceToken != nil ? deviceToken!.lowercased() : ""
        ]

        return parameters
    }
    
    override func headers() -> [String : String]? {
        return nil
    }
        
    public override func method() -> RequestMethod {
        return .post
    }
}
