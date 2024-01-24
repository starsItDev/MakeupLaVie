//  LoginVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 17/04/2023.

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate , UITextViewDelegate {
    
//MARK: - Outlets
    @IBOutlet var inputEmailAddress: UITextField!
    @IBOutlet var inputPassword: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    
//MARK: - Variables
    var params = [String: Any]()
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: - Helper Functions
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
    func postLoginAPI(params: [String: Any]){
        Networking.instance.postApiCall(url: login_url, param: params){(response, error, statusCode) in
            print(response)
            if error == nil && statusCode == 200{
                let body = response["body"].dictionary
                let token_type = body?["token_type"]?.stringValue
                let expires_in = body?["expires_in"]?.intValue
                let access_token = body?["access_token"]?.stringValue
                let refresh_token = body?["refresh_token"]?.stringValue
                let user = body?["user"]?.dictionary
                let id = user?["id"]?.intValue
                let email = user?["email"]?.stringValue
                let first_name = user?["first_name"]?.stringValue
                let last_name = user?["last_name"]?.stringValue
                let created_at = user?["created_at"]?.stringValue
                let updated_at = user?["updated_at"]?.stringValue
                let locale = user?["locale"]?.stringValue
                let phone = user?["phone"]?.stringValue
                let userArr = [id ?? 0, first_name ?? "", last_name ?? "", email ?? "", true, access_token ?? "", refresh_token ?? "", expires_in ?? 0, token_type ?? "", phone ?? ""] as [Any]
                print(userArr)
                UserInfo.storeUserInfoArrayInInstance(array: userArr)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.window?.rootViewController = vc
                appdelegate.window?.makeKeyAndVisible()
            }
            else{
                let error = response["error_code"].stringValue
                utilityFunctions.showAlertWithTitle(title: "", withMessage: error, withNavigation: self)
                print(error)
            }
        }
    }
    
//MARK: - Actions
    @IBAction func logInBtn(_ sender: Any) {
        if (inputEmailAddress?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Email is required", withNavigation: self)
            return
        }
        if (inputPassword?.text?.isEmpty)! {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password is required", withNavigation: self)
            return
        }
        if (inputPassword?.text?.count)! < 6 {
            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Password lenght should be of at least 6 characters!", withNavigation: self)
            return
        }
        else{
            params["grant_type"] = "password"
            params["client_id"] = "2"
            params["client_secret"] = "YDAIQy9cKcL3fPifVF20eRBI0y9de2ab3UMr01KY"
            params["username"] = inputEmailAddress.text
            params["password"] = inputPassword.text
            params["scope"] = ""
            postLoginAPI(params: params)
        }
        //      guard let email = self.inputEmailAddress.text else { return }
        //        guard let password = self.inputPassword.text else { return }
        //
        //        let modelLogin = loginModel(grant_type:"password", client_id: "2", client_secret: "YDAIQy9cKcL3fPifVF20eRBI0y9de2ab3UMr01KY",  username : email , password: password , scope: "")
        //        APIManager.shareInstance.callingLoginAPI(login: modelLogin) { (result) in
        //            switch result {
        //            case .success(let json):
        //                print(json as AnyObject)
        //                let name = (json as! ResponseModel).body.user.firstName
        //                let userToken = (json as! ResponseModel).body.accessToken
        //                TokenService.tokenInstance.saveToken(token: userToken)
        //                let vc = HomeVC.shareInstance()
        //                //let vc = UITabBarController.shareInstance()
        //                //vc.strName = name
        //                self.navigationController?.pushViewController(vc, animated: true)
        ////                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabBar") as? UITabBarController
        ////                self.navigationController?.pushViewController(vc!, animated: true)
        //            case .failure(let err):
        //                print(err.localizedDescription)
        //            }
        //        }
    }
    @IBAction func showPasswordTapped(_ sender: UIButton){
        if inputPassword.isSecureTextEntry {
            inputPassword.isSecureTextEntry = false
            showPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
            showPasswordBtn.tintColor = .darkGray
        } else {
            inputPassword.isSecureTextEntry = true
            showPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            showPasswordBtn.tintColor = .lightGray
        }
    }
    @IBAction func signUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func homeBackbtn(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - Extension LoginVC
extension LoginVC {
    static func shareInstance() -> LoginVC {
        return LoginVC.instantiateFromStoryboard("Main")
    }
}
