//
//  StatisticModel.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import ObjectMapper

public class IntTransform: TransformType {

    public typealias Object = Int
    public typealias JSON = Any?

    public init() {}

    public func transformFromJSON(_ value: Any?) -> Int? {

        var result: Int?

        guard let json = value else {
            return result
        }

        if json is Int {
            result = (json as! Int)
        }
        if json is String {
            result = Int(json as! String)
        }

        return result
    }

    public func transformToJSON(_ value: Int?) -> Any?? {

        guard let object = value else {
            return nil
        }

        return String(object)
    }
}

class StatisticModel: AbstractResponse {
    var spam: Int?
    var allow: Int?
    var sfw: Int?
    
    public override func mapping(map: Map) {
        spam <- (map[Constants.Statistic.statSpam], IntTransform())
        allow <- (map[Constants.Statistic.statAllow], IntTransform())
        sfw <- (map[Constants.Statistic.statSfw], IntTransform())
    }

}
