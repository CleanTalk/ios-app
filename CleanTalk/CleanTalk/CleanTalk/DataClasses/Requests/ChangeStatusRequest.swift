//
//  ChangeStatusRequest.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/9/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import Alamofire

class ChangeStatusRequest: AbstractRequest<ChangeStatusModel> {
    var authKey: String = ""
    var messageId: String = ""
    var status: Bool = false
    
    override init () {
        super.init()
        self.serverURL = "https://moderate.cleantalk.org/api2.0"
        self.encodingType = JSONEncoding.default
    }
    
    override func urlString() -> String {
        return ""
    }
    
    override func parameters() -> [String : Any]? {
        let parameters = [
            "method_name": "send_feedback",
            "auth_key": authKey,
            "feedback" : messageId + (self.status == true ? "1" : "0")
        ]
        
        return parameters
    }
    
    public override func method() -> RequestMethod {
        return .post
    }
}
