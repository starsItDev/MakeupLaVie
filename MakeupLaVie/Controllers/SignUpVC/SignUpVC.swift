//
//  SignUpVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 17/04/2023.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController , UITextViewDelegate{
    
    @IBOutlet var inPutName: UITextField!
    @IBOutlet var inPutLastName: UITextField!
    @IBOutlet var inPutEmailAddress: UITextField!
    @IBOutlet var inPutPhoneNumber: UITextField!
    @IBOutlet var inPutPassword: UITextField!
    @IBOutlet var inPutConfrimPassword: UITextField!
    @IBOutlet var signUp: UIButton!
    @IBOutlet weak var confirmPasswordBtn: UIButton!
    @IBOutlet weak var passwordBtn: UIButton!
    
//MARK: - Variables
    var params = [String: String]()
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: - Helper Functions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func handleTap() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpBtn(_ sender: UIButton) {
        if (inPutName?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "First Name is required", withNavigation: self)
            return
        }
        if (inPutLastName?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Last Name is required", withNavigation: self)
            return
        }
        if (inPutEmailAddress?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Email is required", withNavigation: self)
            return
        }
        if (inPutPhoneNumber?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Phone Number is required.", withNavigation: self)
            return
        }
        if (inPutPassword?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password is required.", withNavigation: self)
            return
        }
        if (inPutPassword?.text?.count)! < 6 {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password length should be at least 6 characters long", withNavigation: self)
            return
        }
        if (inPutConfrimPassword?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Confirm Password is required.", withNavigation: self)
            return
        }
        if inPutPassword?.text != inPutConfrimPassword?.text {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password does not match!", withNavigation: self)
            return
        }
        else{
            params["first_name"] = self.inPutName.text
            params["last_name"] = self.inPutLastName.text
            params["email"] = self.inPutEmailAddress.text
            params["phone"] = self.inPutPhoneNumber.text
            params["password"] = self.inPutPassword.text
            params["password_confirmation"] = self.inPutConfrimPassword.text
            print(params)
            self.postSignUpAPI(params: params)
        }
        //        let register =  SignupModel(first_name: firstname, last_name: lastnmae,email: email,phone: phone, password: password,password_confirmation: comfrimPassword)
        //
        //                APIManager.shareInstance.callingSignUpAPI(signUp: register){
        //                    (isSuccess, str ) in
        //                    if isSuccess {
        //
        //                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        //                        self.navigationController?.pushViewController(vc!, animated: true)
        //                    }else {
        //                        self.alert(message: str, title: "Alert")
        //                    }
        //                }
    }
    func postSignUpAPI(params: [String: Any]){
        Networking.instance.postApiCall(url: signUp_url, param: params){(response, error, statusCode) in
            print(response)
            if error == nil && statusCode == 200{
                let body = response["body"].dictionary
                let message = body?["message"]?.stringValue
                utilityFunctions.showAlertWithTitle(title: "Verification Required", withMessage: message ?? "", withNavigation: self)
                self.navigationController?.popViewController(animated: true)
                //                let user = body?["user"]?.dictionary
                //                let id = user?["id"]?.intValue
                //                let first_name = user?["first_name"]?.stringValue
                //                let last_name = user?["last_name"]?.stringValue
                //                let created_at = user?["created_at"]?.stringValue
                //                let updated_at = user?["updated_at"]?.stringValue
                //                let locale = user?["locale"]?.stringValue
                //                let phone = user?["phone"]?.stringValue
                //                let account_type = user?["account_type"]?.intValue
            }
            else{
                let body = response["body"].dictionary
                let message = body?["message"]?.stringValue
                utilityFunctions.showAlertWithTitle(title: "", withMessage: message ?? "", withNavigation: self)
            }
        }
    }
    @IBAction func showPaswordTapped(_ sender: UIButton) {
        if inPutPassword.isSecureTextEntry {
            inPutPassword.isSecureTextEntry = false
            passwordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordBtn.tintColor = .darkGray
        } else {
            inPutPassword.isSecureTextEntry = true
            passwordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordBtn.tintColor = .lightGray
        }
    }
    @IBAction func showConfirmPasswordTapped(_ sender: UIButton) {
        if inPutConfrimPassword.isSecureTextEntry {
            inPutConfrimPassword.isSecureTextEntry = false
            confirmPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
            confirmPasswordBtn.tintColor = .darkGray
        } else {
            inPutConfrimPassword.isSecureTextEntry = true
            confirmPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            confirmPasswordBtn.tintColor = .lightGray
        }
    }
}

//MARK: - Extension SignUpVC
extension SignUpVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == inPutEmailAddress {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: (textField.text ?? "") + string)
        } else if textField == inPutPassword {
            let validCharacters = CharacterSet.alphanumerics
            return string.rangeOfCharacter(from: validCharacters.inverted) == nil
        }
        return true
    }
}
