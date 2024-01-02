
import Foundation
import Alamofire
import SwiftyJSON


class Networking {

    static let instance = Networking()
    

    //Calling get Api call

    func getApiCall(url: String,completionHandler: @escaping (_ Response:JSON,_ Error:String?, _ StatusCode: Int) -> ()) {
//      let token =  UserDefaults.standard.string(forKey: "TokenString") ?? ""
        let token = UserInfo.shared.accessToken
          var header: HTTPHeaders = [:]
          if token != "" {
            header = [
              "Authorization": "Bearer \(token)",
              "Accept": "application/json"
            ]
          }else{
            header = [
              "Authorization": "nil",
              "Accept": "application/json"
            ]
          }
      print(header)
        AF.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default,headers: header).response { (response) in

            print("Request: \(String(describing: response.request))")   // original url request

            print("Response: \(String(describing: response.response))") // http url response

            print("Result: \(response.result)")// response serialization result

            let statusCode = response.response?.statusCode

            switch response.result {

            case .success(_):

                guard let data = response.data else {return}

                print(data)

                completionHandler(JSON(data),nil, statusCode ?? -1)

            case .failure(let error): completionHandler(JSON(error),error.localizedDescription, statusCode ?? -1)

            }

        }

    }
    
    //calling get api with params
    func getApiCallWithParams(url: String,param: Parameters,completionHandler: @escaping (_ Response:JSON,_ Error:String?, _ StatusCode: Int) -> ()) {
//      let token =  UserDefaults.standard.string(forKey: "TokenString") ?? ""
        let token = UserInfo.shared.accessToken
          var header: HTTPHeaders = [:]
          if token != "" {
            header = [
              "Authorization": "Bearer \(token)",
              "Accept": "application/json"
            ]
          }else{
            header = [
              "Authorization": "nil",
              "Accept": "application/json"
            ]
          }
      print(header)
        print(url)
        print(param)
        
        AF.request(url , method: .get, parameters: param, encoding: URLEncoding.default,headers: header).response { (response) in

            print("Request: \(String(describing: response.request))")   // original url request

            print("Response: \(String(describing: response.response))") // http url response

            print("Result: \(response.result)")// response serialization result

            let statusCode = response.response?.statusCode

            switch response.result {

            case .success(_):

                guard let data = response.data else {return}

                print(data)

                completionHandler(JSON(data),nil, statusCode ?? -1)

            case .failure(let error): completionHandler(JSON(error),error.localizedDescription, statusCode ?? -1)

            }

        }

    }

    //Calling post api call

    func postApiCall(url: String,param:[String:Any],completionHandler: @escaping (_ Response:JSON,_ Error:String?, _ StatusCode: Int) -> ()) {
        let token = UserInfo.shared.accessToken
        //let token =  UserDefaults.standard.string(forKey: "TokenString") ?? ""
               var header: HTTPHeaders = [:]
               if token != "" {
                   header = [
                     "Authorization": "Bearer \(token)",
                     "Accept": "application/json"
                   ]
               }else{
                 header = [
                   "Authorization": "nil",
                   "Accept": "application/json"
                 ]
               }
      print(header)
      //print(url)
      print(param)
        AF.request(url , method: .post, parameters: param, encoding: JSONEncoding.default,headers: header).response { (response) in

            print("Request: \(String(describing: response.request))")   // original url request
          
            print("Response: \(String(describing: response.response))") // http url response
         
            print("Result: \(response.result)")// response serialization result
          
            let statusCode = response.response?.statusCode
            switch response.result {

            case .success(_):

                guard let data = response.data else {return}

                completionHandler(JSON(data),nil, statusCode ?? -1)

            case .failure(let error): completionHandler(JSON(error),error.localizedDescription, statusCode ?? -1)

            }

        }

    }

    

    //Calling Delete api call

    func DeleteApiCall(url: String,completionHandler: @escaping (_ Response:JSON,_ Error:String?, _ StatusCode: Int) -> ()) {
        let token = UserInfo.shared.accessToken
      //let token =  UserDefaults.standard.string(forKey: "TokenString") ?? ""
      var header: HTTPHeaders = [:]
      if token != "" {
        header = [
          "Authorization": "JWT \(token)",
          "Accept": "application/json"
        ]
      }else{
        header = [
          "Authorization": "nil",
          "Accept": "application/json"
        ]
      }
      
        AF.request(url , method: .delete, parameters: nil, encoding: JSONEncoding.default,headers: header).response { (response) in
          
            print("Request: \(String(describing: response.request))")   // original url request

            print("Response: \(String(describing: response.response))") // http url response

            print("Result: \(response.result)")// response serialization result

            let statusCode = response.response?.statusCode

            switch response.result {

            case .success(_):

                guard let data = response.data else {return}

                print(data)

                completionHandler(JSON(data),nil, statusCode ?? -1)

            case .failure(let error): completionHandler(JSON(error),error.localizedDescription, statusCode ?? -1)

            }

        }

    }

    

    //Calling Put api call

    func putApiCall(url: String,param:[String:Any],completionHandler: @escaping (_ Response:JSON,_ Error:String?, _ StatusCode: Int) -> ()) {

        AF.request(url , method: .post, parameters: param, encoding: JSONEncoding.default,headers: nil).response { (response) in

            print("Request: \(String(describing: response.request))")   // original url request

            print("Response: \(String(describing: response.response))") // http url response

            print("Result: \(response.result)")// response serialization result

            let statusCode = response.response?.statusCode

            switch response.result {

            case .success(_):

                guard let data = response.data else {return}

                print(data)

                completionHandler(JSON(data),nil, statusCode ?? -1)

            case .failure(let error): completionHandler(JSON(error),error.localizedDescription, statusCode ?? -1)

            }

        }

    }

    

    //Calling Listing Api

//    func listingApiCall(url:String,param:[String:Any],ImagesArray : [UIImage] ,completionHandler: @escaping (_ Response:JSON,_ Error:String?, _ StatusCode: Int) -> ()) {
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//            var imagesData : [Data] = []
//
//            for _image in ImagesArray{
//
//              if let data: Data = (_image as UIImage).UIImageJPEGRepresentation(compressionQuality: 0.9) {
//
//                    imagesData.append(data)
//
//                    print("Image Data ==",ImagesArray)
//
//                }
//
//            }
//
//            for i in 0..<imagesData.count{
//
//                multipartFormData.append(imagesData[i], withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//
//            }
//
//            for (key, value) in param {
//
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//
//            }
//
//        }, to:url,method: .post){ (result) in
//
//
//
//            switch result {
//
//            case .success(let upload, _, _):
//
//
//
//                upload.uploadProgress(closure: { (progress) in
//
//                    print("progess == \(progress.fractionCompleted)")
//
//                    //Print progress
//
//                })
//
//
//
//                upload.responseJSON { response in
//
//                    print("Request: \(String(describing: response.request))")   // original url request
//
//                    print("Response: \(String(describing: response.response))") // http url response
//
//                    print("Result: \(response.result)")// response serialization result
//
//                    print(response)
//
//                    let statusCode = response.response?.statusCode
//
//                    guard let data = response.data else {return}
//
//                    print(data)
//
//                    completionHandler(JSON(data),nil, statusCode ?? -1)
//
//                }
//
//
//
//            case .failure(let error):
//
//                //print encodingError.description
//
//                print("Response Home --\(error.localizedDescription)")
//
//                completionHandler(JSON(error),error.localizedDescription, 500)
//
//                break
//
//            }
//
//        }
//
//    }

    

}
