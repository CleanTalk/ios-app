//
//  MainStatsRequest.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

class MainStatsRequest: AbstractRequest<ServiceModel> {
    
    public var pageNumber: Int? = 1
    public var sessionId: String?
    
    override func urlString() -> String {
        return "my/main?app_mode=1&all_results=1"
    }
    
    override func parameters() -> [String : Any]? {
        let parameters = [
            "app_session_id": self.sessionId ?? ""
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
