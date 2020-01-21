//
//  DetailStatsRequest.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

class DetailStatsRequest: AbstractRequest<DetailStatisticModel> {
    
    public var sessionId: String?
    public var time: String?
    public var serviceId: String?
    public var days: String?
    public var index:Int = 0
    public var allow:Bool = false
    public var isSpamRequest: Bool = true
    
    override func urlString() -> String {
        return self.isSpamRequest == true ? "my/show_requests?app_mode=1" : "my/show_sfw?app_mode=1"
    }
    
    override func parameters() -> [String : Any]? {
        var parameters = [
            "start_from": self.time ?? "",
            "service_id" : self.serviceId ?? "",
            "app_session_id" : self.sessionId ?? ""
        ]
        
        if let day = self.days {
            parameters["days"] = day
        }
        
        if self.isSpamRequest == true {
            parameters["allow"] = self.allow == true ? "1" : "0"
        }
        
        return parameters
    }
    
    override func headers() -> [String : String]? {
        return nil
    }
    
    public override func method() -> RequestMethod {
        return .post
    }
}
