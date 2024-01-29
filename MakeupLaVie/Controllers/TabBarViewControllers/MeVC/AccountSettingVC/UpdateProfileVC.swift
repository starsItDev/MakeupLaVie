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
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.text = UserInfo.shared.firstName
        self.lastName.text = UserInfo.shared.lastName
        self.phoneNoTxt.text = UserInfo.shared.phoneNo
        firstName.delegate = self
        lastName.delegate = self
        phoneNoTxt.delegate = self
        
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
                    let body = response["body"].dictionary
                    let user = body?["user"]?.dictionary
                    let id = user?["id"]?.intValue
                    let first_name = user?["first_name"]?.stringValue
                    let last_name = user?["last_name"]?.stringValue
                    
                    let phone = user?["phone"]?.stringValue
                    
                    UserInfo.shared.userId = id ?? 0
                    UserInfo.shared.firstName = first_name ?? ""
                    UserInfo.shared.lastName = last_name ?? ""
                    UserInfo.shared.phoneNo = phone ?? ""
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            //let VC: MeVC = self.storyboard?.instantiateViewController(withIdentifier: "MeVC") as! MeVC
            //self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

extension UpdateProfileVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case firstName:
            firstNameLbl.isHidden = false
            firstName.layer.borderWidth = 1
            firstName.layer.borderColor = UIColor.red.cgColor
            firstName.layer.cornerRadius = 5
        case lastName:
            lastNameLbl.isHidden = false
            lastName.layer.borderWidth = 1
            lastName.layer.borderColor = UIColor.red.cgColor
            lastName.layer.cornerRadius = 5
        case phoneNoTxt:
            numberLbl.isHidden = false
            phoneNoTxt.layer.borderWidth = 1
            phoneNoTxt.layer.borderColor = UIColor.red.cgColor
            phoneNoTxt.layer.cornerRadius = 5
        default:
            break
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstName:
            if firstName.text?.isEmpty ?? false {
                firstNameLbl.isHidden = true
            }
            firstName.layer.borderWidth = 1
            firstName.layer.borderColor = UIColor.systemGray5.cgColor
            firstName.layer.cornerRadius = 5
        case lastName:
            if lastName.text?.isEmpty ?? false {
                lastNameLbl.isHidden = true
            }
            lastName.layer.borderWidth = 1
            lastName.layer.borderColor = UIColor.systemGray5.cgColor
            lastName.layer.cornerRadius = 5
        case phoneNoTxt:
            if phoneNoTxt.text?.isEmpty ?? false {
                numberLbl.isHidden = true
            }
            phoneNoTxt.layer.borderWidth = 1
            phoneNoTxt.layer.borderColor = UIColor.systemGray5.cgColor
            phoneNoTxt.layer.cornerRadius = 5
        default:
            break
        }
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
}
