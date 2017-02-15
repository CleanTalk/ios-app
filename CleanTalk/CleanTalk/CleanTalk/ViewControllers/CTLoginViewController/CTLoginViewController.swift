//
//  CTLoginViewController.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 1/31/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

class CTLoginViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet fileprivate weak var passwordTextFiled: UITextField!
    @IBOutlet fileprivate weak var emailTextFiled: UITextField!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        
        if let text = UserDefaults.standard.value(forKey: Constants.Defines.lastLogin) as? String {
            self.emailTextFiled.text = text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func openURLFromString(string: String) {
        let url = URL(string:string)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK - Buttons
    @IBAction func loginPressed() {
        if let email = self.emailTextFiled.text, let password = self.passwordTextFiled.text {
            self.activityIndicator.startAnimating()
            
            let request = LoginRequest()
            request.login = email
            request.password = password
            request.deviceToken = UserDefaults.standard.value(forKey: Constants.Defines.deviceToken) as? String
            
            AlamofireDispatcher.shared.run(request: request, keyPath: nil) { (response: Response<LoginModel>) in
                switch response {
                case .success(let model):
                    ModelsManager.shared.loginModel = model
                    if model.success == 1 {
                        UserDefaults.standard.setValue(model.sessionId, forKey: Constants.Defines.sessionId)
                        UserDefaults.standard.setValue(true, forKey: Constants.Defines.alreadyLogin)
                        let statisticVC = CTStatisticViewController(nibName: "CTStatisticViewController", bundle: nil)
                        self.navigationController?.pushViewController(statisticVC, animated: true)
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.activityIndicator.stopAnimating()
                        ModelsManager.shared.showAlertMessage(withError: nil)
                    }
                case .error:
                    self.activityIndicator.stopAnimating()
                    ModelsManager.shared.showAlertMessage(withError: nil)
                }
            }
        }
    }

    @IBAction func registerPressed() {
        self.openURLFromString(string: Constants.URL.registrationURL)
    }

    @IBAction func resetPasswordPressed() {
        self.openURLFromString(string: Constants.URL.passwordURL)
    }

}

extension CTLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.isEqual(self.emailTextFiled) {
            self.passwordTextFiled.becomeFirstResponder()
        }
        
        return true
    }
}
