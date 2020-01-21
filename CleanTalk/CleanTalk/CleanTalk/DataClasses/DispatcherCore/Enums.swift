//
//  Enums.swift
//  RequestDispatcher
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import Foundation
import Alamofire

//MARK: HTTP methods
public enum RequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

//MARK: Errors
public enum Response<T> {
    case success(T)
    case error(Error)
}

public enum DispatcherDataError : Error {
    case parseError(Any)
}
