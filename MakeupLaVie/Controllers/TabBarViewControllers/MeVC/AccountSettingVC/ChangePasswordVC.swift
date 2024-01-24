//
//  ChangePasswordVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var currentPasswordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ChangePasswordBtnTapped(_ sender: Any) {
        if (currentPasswordTxt?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Current Password is required", withNavigation: self)
            return
        }
        if (newPasswordTxt?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "New Password is required", withNavigation: self)
            return
        }
        if (confirmPasswordTxt?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Confirm Password is required", withNavigation: self)
            return
        }
        else{
            var params = [String: Any]()
            params["old_password"] = currentPasswordTxt.text
            params["password"] = confirmPasswordTxt.text
            params["password_confirmation"] = newPasswordTxt.text
            let url = base_url + "user/password"
            Networking.instance.putApiCall(url: url, param: params){(response, error, statusCode) in
                if error == nil && statusCode == 200{
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
