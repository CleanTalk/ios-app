//
//  ChangeStatusModel.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/9/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import ObjectMapper

class ChangeStatusModel: AbstractResponse {
    var comment: String?
    var received: NSNumber?
    
    public override func mapping(map: Map) {
        comment <- map[Constants.Update.updateComment]
        received <- map[Constants.Update.updateReceived]
    }
}
