//
//  StatisticModel.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import ObjectMapper

class StatisticModel: AbstractResponse {
    var spam: Int?
    var allow: Int?
    var sfw: String?
    
    public override func mapping(map: Map) {
        spam <- map[Constants.Statistic.statSpam]
        allow <- map[Constants.Statistic.statAllow]
        sfw <- map[Constants.Statistic.statSfw]
    }

}
