//
//  Constant.swift
//  MakeupLaVie
//
//  Created by StarsDev on 04/05/2023.
//

import Foundation

let base_url = "https://shop.plazauk.com/api/"
let signUp_url = "\(base_url)signup"
let login_url = "\(base_url)login"


struct TokenKey {
    static let userLogin = "USER_LOGIN_KEY"
}



enum ConstantA {
    enum APIA {
        static let productURLA = "\(base_url)home"
    }
}
enum Constant {
    enum API {
        static let productURL = "\(base_url)categories"
    }
}
enum ConstantViewProduct {
    enum APIViewProduct {
       
            static let productViewProduct = "\(base_url)product/view/26"
        }
    }


enum ConstantBrowseProduct {
    enum APIBrowseProduct {
        static let productBrowseProduct = "\(base_url)products"
    }
}

enum ConstantWishList {
    enum APIWishList {
        static let wishListproduct = "\(base_url)wishlist"
    }
}
