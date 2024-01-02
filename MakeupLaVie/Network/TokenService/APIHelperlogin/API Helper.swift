//
//  API Helper.swift
//  MakeupLaVie
//
//  Created by StarsDev on 03/05/2023.
//

import SwiftyJSON
import Alamofire
import Foundation
import UIKit

enum APIError: Error{
    case custom(message: String)
}
typealias Handler = (Swift.Result<Any?, APIError>) -> Void

class APIManager {
    static let shareInstance = APIManager()
    
    func callingSignUpAPI(signUp: SignupModel,completionHandler: @escaping (Bool,String) -> ()) {
        let headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(signUp_url,method: .post, parameters: signUp,encoder: JSONParameterEncoder.default,headers: headers).response { response  in
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(true, "User Register Succesfully")
                    }else{
                        completionHandler(false ,"The email has already been taken")
                    }
                    print(json)
                }catch{
                    print(error.localizedDescription)
                    completionHandler(false, "The email must be a valid email address")
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false, "The email must be a valid email address")
            }
        }
    }
    
    func callingLoginAPI( login: loginModel , completionHandler : @escaping Handler) {
        let headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        AF.request(login_url,method: .post, parameters: login,encoder: JSONParameterEncoder.default,headers: headers).response { response  in
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do{
                    let json = try JSONDecoder().decode(ResponseModel.self, from: data!)
                    print(json)
                // let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    }else{
                        completionHandler(.failure(.custom(message: "Please Check Your Network")))
                    }
                    print(json)
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "The email has already been taken")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "The email has already been taken")))
            }
        }
    }
}

extension UIViewController {
  func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
