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
    @IBOutlet weak var currentPasswdEye: UIButton!
    @IBOutlet weak var newPasswdEye: UIButton!
    @IBOutlet weak var confirmPasswdEye: UIButton!
    
//MARK: - Override Function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: - Helper Function
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
//MARK: - Actions
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func currentEyeBtn(_ sender: UIButton) {
        if currentPasswordTxt.isSecureTextEntry {
            currentPasswordTxt.isSecureTextEntry = false
            currentPasswdEye.setImage(UIImage(systemName: "eye"), for: .normal)
            currentPasswdEye.tintColor = .darkGray
        } else {
            currentPasswordTxt.isSecureTextEntry = true
            currentPasswdEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            currentPasswdEye.tintColor = .lightGray
        }
    }
    @IBAction func newPasswdEyeBtn(_ sender: UIButton) {
        if newPasswordTxt.isSecureTextEntry {
            newPasswordTxt.isSecureTextEntry = false
            newPasswdEye.setImage(UIImage(systemName: "eye"), for: .normal)
            newPasswdEye.tintColor = .darkGray
        } else {
            newPasswordTxt.isSecureTextEntry = true
            newPasswdEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            newPasswdEye.tintColor = .lightGray
        }
    }
    @IBAction func confirmEyeBtn(_ sender: UIButton) {
        if confirmPasswordTxt.isSecureTextEntry {
            confirmPasswordTxt.isSecureTextEntry = false
            confirmPasswdEye.setImage(UIImage(systemName: "eye"), for: .normal)
            confirmPasswdEye.tintColor = .darkGray
        } else {
            confirmPasswordTxt.isSecureTextEntry = true
            confirmPasswdEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            confirmPasswdEye.tintColor = .lightGray
        }
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
        if (newPasswordTxt?.text?.count)! < 6 {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password length should be at least 6 characters long", withNavigation: self)
            return
        }
        if (confirmPasswordTxt?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Confirm Password is required", withNavigation: self)
            return
        }
        if newPasswordTxt?.text != confirmPasswordTxt?.text {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password does not match!", withNavigation: self)
            return
        }
        else {
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
