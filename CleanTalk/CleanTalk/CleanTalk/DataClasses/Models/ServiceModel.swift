//
//  StatisticModel.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import ObjectMapper

class ServiceModel: AbstractResponse {
    var siteName: String?
    var siteIcon: String?
    var detailStats: [DetailStatisticModel]?
    var serviceId: Int?
    var statsToday: StatisticModel?
    var statsYesterday: StatisticModel?
    var statsWeek: StatisticModel?
    var authKey: String = ""
    
    public override func mapping(map: Map) {
        siteName <- map[Constants.Service.serviceName]
        siteIcon <- map[Constants.Service.serviceIcon]
        serviceId <- (map[Constants.Service.serviceId], IntTransform())
        statsToday <- map[Constants.Service.serviceStatToday]
        statsYesterday <- map[Constants.Service.serviceStatYesterday]
        statsWeek <- map[Constants.Service.serviceStatWeek]
        authKey <- map[Constants.Service.serviceAuthKey]
    }
    
    func checkIfNeedToShowSFWView() -> Bool {
        return self.statsToday?.sfw != nil || self.statsYesterday?.sfw != nil || self.statsWeek?.sfw != nil
    }
}
