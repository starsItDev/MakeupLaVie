//
//  UpdateProfileVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class UpdateProfileVC: UIViewController {

    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet weak var phoneNoTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.text = UserInfo.shared.firstName
        self.lastName.text = UserInfo.shared.lastName
        self.phoneNoTxt.text = UserInfo.shared.phoneNo
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField
        print(nextField as Any)
        if textField.tag == 1 {
            textField.resignFirstResponder()
        }
        else if nextField != nil {
            nextField?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upDataBtn(_ sender: UIButton) {
        
        if (firstName?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "First Name is required", withNavigation: self)
            return
        }
        if (lastName?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Last Name is required", withNavigation: self)
            return
        }
        if (phoneNoTxt?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Phone Number is required", withNavigation: self)
            return
        }
        else{
            var params = [String: Any]()
            params["first_name"] = firstName.text
            params["last_name"] = lastName.text
            params["phone"] = phoneNoTxt.text
            let url = base_url + "user/profile"
            Networking.instance.putApiCall(url: url, param: params){(response, error, statusCode) in
                if error == nil && statusCode == 200{
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            //let VC: MeVC = self.storyboard?.instantiateViewController(withIdentifier: "MeVC") as! MeVC
            //self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}
