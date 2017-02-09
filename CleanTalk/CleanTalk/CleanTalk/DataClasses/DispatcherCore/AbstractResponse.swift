//
//  HARAbstractModel.swift
//  HelpAround
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import Foundation
import ObjectMapper

public class AbstractResponse: Mappable {
  
    public required init?(map: Map) {
        
    }
    
    public init() {

    }
    
    public func mapping(map: Map) {
        preconditionFailure("Override this in subclasses")
    }
    
}
