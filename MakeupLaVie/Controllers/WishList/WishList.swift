//
//  WishList.swift
//  MakeupLaVie
//
//  Created by Apple on 03/08/2023.
//

import Foundation

class WishList{
    
    public static func wishListAPICall(id: Int, completion: @escaping (Bool) -> Void){
        let url = base_url + "wishlist"
        let params = ["id": id]
        print(params)
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            print(response)
            if error == nil && statusCode == 200{
                let status = response["statusCode"].intValue
                completion(true)
            }
            else{
                let err = response["error"].boolValue
                print(err)
                completion(false)
            }
        }
    }
}
