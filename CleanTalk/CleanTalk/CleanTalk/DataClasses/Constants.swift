//
//  Constants.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 1/31/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import Foundation

public enum StatisticType : Int {
    case enabledSpamToday           = 100
    case enabledSpamYesterday
    case enabledSpamWeek
    case disabledSpamToday
    case disabledSpamYesterday
    case disabledSpamWeek
    case enabledFirewallToday
    case enabledFirewallYesterday
    case enabledFirewallWeek
}

struct Constants {
    struct URL {
        static let apiURL = "https://cleantalk.org/"
        static let registrationURL = "https://cleantalk.org/register"
        static let passwordURL = "https://cleantalk.org/my/reset_password"
    }
    
    struct Defines {
        static let alreadyLogin = "user_login"
        static let sessionId = "app_session_id"
        static let timeInterval = "timestamp"
        static let deviceToken = "device_token"
        static let lastLogin = "last_login"
        static let success = "success"
        static let requests = "requests"
    }
    
    struct Service {
        static let serviceName = "servicename"
        static let serviceIcon = "favicon_url"
        static let serviceId = "service_id"
        static let serviceStatToday = "today"
        static let serviceStatYesterday = "yesterday"
        static let serviceStatWeek = "week"
        static let serviceKey = "services"
        static let serviceAuthKey = "auth_key"
    }
    
    struct  Statistic {
        static let statSpam = "spam"
        static let statAllow = "allow"
        static let statSfw = "sfw"
    }
    
    struct DetailStatistic {
        static let detailStatDate = "datetime"
        static let detailStatApproved = "approved"
        static let detailStatEmail = "sender_email"
        static let detailStatUser = "sender_nickname"
        static let detailStatType = "type"
        static let detailStatMessage = "message"
        static let detailStatRequestId = "request_id"
        static let detailStatAllow = "allow"
    }
    
    struct Update {
        static let updateComment = "comment"
        static let updateReceived = "received"
    }
    
    struct SFW {
        static let sfwIP = "ip"
        static let sfwCountry = "country"
        static let sfwPassed = "allow"
        static let sfwTotal = "total"
    }
}
