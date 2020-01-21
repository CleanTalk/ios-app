//
//  DetailStatisticModel.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import ObjectMapper

class DetailStatisticModel: AbstractResponse {
    var date: String?
    var sender: String?
    var email: String?
    var type: String?
    var message: String?
    var approved: String = "2"
    var allow: String?
    var requestId: String?
    var sfwIp: String?
    var sfwCountry: String?
    var sfwPassed: String?
    var sfwTotal: String?
    
    public override func mapping(map: Map) {
        date <- map[Constants.DetailStatistic.detailStatDate]
        sender <- map[Constants.DetailStatistic.detailStatUser]
        email <- map[Constants.DetailStatistic.detailStatEmail]
        type <- map[Constants.DetailStatistic.detailStatType]
        message <- map[Constants.DetailStatistic.detailStatMessage]
        approved <- map[Constants.DetailStatistic.detailStatApproved]
        allow <- map[Constants.DetailStatistic.detailStatAllow]
        requestId <- map[Constants.DetailStatistic.detailStatRequestId]
        sfwIp <- map[Constants.SFW.sfwIP]
        sfwCountry <- map[Constants.SFW.sfwCountry]
        sfwPassed <- map[Constants.SFW.sfwPassed]
        sfwTotal <- map[Constants.SFW.sfwTotal]
    }
}
