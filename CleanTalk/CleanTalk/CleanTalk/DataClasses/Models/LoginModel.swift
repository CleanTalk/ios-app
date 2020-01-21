//
//  LoginModel.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginModel: AbstractResponse {
    var success: Int?
    var sessionId: String?
    
    public override func mapping(map: Map) {
        success <- map[Constants.Defines.success]
        sessionId <- map[Constants.Defines.sessionId]
    }
}
