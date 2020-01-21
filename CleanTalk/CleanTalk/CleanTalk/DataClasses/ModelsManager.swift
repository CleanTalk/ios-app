//
//  ModelsManager.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/2/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

class ModelsManager: NSObject {
    static let shared = ModelsManager()
    
    public var loginModel: LoginModel?
    public var statisticModelsList: [ServiceModel]?
    
    func showAlertMessage(withError error:Error?) {
        let alert = UIAlertView(title: NSLocalizedString("ERROR", comment: ""), message: error?.localizedDescription ?? NSLocalizedString("ERROR_MESSAGE", comment: ""), delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func getSessionId() -> String? {
        return self.loginModel?.sessionId
    }
}
