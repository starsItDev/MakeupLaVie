//
//  EndPointType.swift
//  MakeupLaVie
//
//  Created by StarsDev on 29/05/2023.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
//    var body: Codable? { get }
//    var headers: [String: String]? { get }
}
enum EndPointItems {
   case home
   case categorie
    case products
}
//"https://shop.plazauk.com/api/home"

extension EndPointItems:EndPointType {
    var path: String {
        switch self{
        case .home:
            return "home"
        case .categorie:
            return "categories"
        case .products:
            return "products"
        }
        
    }
    
    var baseURL: String {
        return "https://shop.plazauk.com/api/"
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .home:
            return .get
        case .categorie:
            return .get
        case .products:
            return .get
        }
    }
}

//                APIManagersViewProduct.shared.fetchProduct { response in
//                            switch response {
//                            case.success(let products):
//                                print(products)
//                            case.failure(let products):
//                                print(products)
//                            }
//                        }


