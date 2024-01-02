//
//  APIManager.swift
//  MakeupLaVie
//
//  Created by StarsDev on 23/05/2023.
//

import Foundation
import UIKit

typealias HandlerIOS<T> = (Result<T, DataError>) -> Void

let accessToken = UserInfo.shared.accessToken

final class APIManagerIOS {
  static let shared = APIManagerIOS ()
    private init () {}
    func request<T: Codable>(
    modelType: T.Type,
    type:EndPointType,
    completion: @escaping HandlerIOS<T>
    ){
        guard let url = type.url else { return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        
               URLSession.shared.dataTask(with: request) { data, response, error in
                   guard let data , error == nil else {
                       completion(.failure(.invalidData))
                       return
                   }
                   guard let response = response as? HTTPURLResponse,
                         200 ... 299 ~= response.statusCode else {
                       completion(.failure(.invalidResponse))
                             return
                         }
                   do{
                       let homePage = try JSONDecoder().decode(modelType, from: data)
                       completion(.success(homePage))
                   }catch{
                       completion(.failure(.network(error)))
                   }
               }.resume()
    }
}


typealias HandlerA = (Result< CategoriesModel, DataError>) -> Void

final class APIManagers {
  static let shared = APIManagers()
    private init () {}
    
    func fetchProduct(completion: @escaping HandlerA ) {
        guard let url = URL(string: Constant.API.productURL) else {
            completion(.failure(.invalidURL))
            return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data , error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                      return
                  }
            do{
                let homePage = try JSONDecoder().decode(CategoriesModel.self, from: data)
                completion(.success(homePage))
            }catch{
                completion(.failure(.network(error)))
            }
        }.resume()
        print("Ended")
    }
}


typealias HandlerViewProduct = (Result< ViewProductModel, DataError>) -> Void
final class APIManagersViewProduct {
  static let shared = APIManagersViewProduct()
    private init () {}

    func fetchProduct(completion: @escaping HandlerViewProduct ) {

        guard let url = URL(string: ConstantViewProduct.APIViewProduct.productViewProduct) else { return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data , error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                      return
                  }
            do{
                let homePage = try JSONDecoder().decode(ViewProductModel.self, from: data)
                completion(.success(homePage))
            }catch{
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}
typealias HandlerBrowseProduct = (Result< BrowseProductModel, DataError>) -> Void
final class APIManagersBrowseProduct {
  static let shared = APIManagersBrowseProduct()
    private init () {}

    func fetchProduct(completion: @escaping HandlerBrowseProduct ) {

        guard let url = URL(string: ConstantBrowseProduct.APIBrowseProduct.productBrowseProduct) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data , error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                      return
                  }
            do{
                let homePage = try JSONDecoder().decode(BrowseProductModel.self, from: data)
                completion(.success(homePage))
            }catch{
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias WishListProduct = (Result< WishListModel, DataErrorWishList>) -> Void
final class APIManagersWishList {
    static let shared = APIManagersWishList()
    private init() {}
    
    func fetchProduct(completion: @escaping (Result<WishListModel, DataErrorWishList>) -> Void) {
        guard let url = URL(string: ConstantWishList.APIWishList.wishListproduct) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        // Set additional headers if needed
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidData))
                return
            }
            
            guard 200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let wishListModel = try JSONDecoder().decode(WishListModel.self, from: data)
                completion(.success(wishListModel))
            } catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}

enum DataErrorWishList: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}
