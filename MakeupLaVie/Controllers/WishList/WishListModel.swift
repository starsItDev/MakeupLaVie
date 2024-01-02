//
//  WishListModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 21/06/2023.
import UIKit

// MARK: - Welcome
struct WishListModel: Codable {
    let statusCode: Int
    let body: WishListBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct WishListBody: Codable {
    let totalItemCount, totalPages: Int
    let response: [ResponseWishlist]
}

// MARK: - Response
struct ResponseWishlist: Codable {
    let id: Int
    let title, description, keywords: String
    let photoID, ownerID, categoryID, status: Int
    let price, discount: String
    let stock, viewCount, sellCount, brandID: Int
    let createdAt, updatedAt: String
    let featured, sponsored, newlabel, hotlabel: Int
    let salelabel, speciallabel: Int
    let image, imageProfile, imageIcon: String
    let hasCompare, hasWishlist, hasCartItem: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, description, keywords
        case photoID = "photo_id"
        case ownerID = "owner_id"
        case categoryID = "category_id"
        case status, price, discount, stock
        case viewCount = "view_count"
        case sellCount = "sell_count"
        case brandID = "brand_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case featured, sponsored, newlabel, hotlabel, salelabel, speciallabel, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
        case hasCompare, hasWishlist, hasCartItem
    }
}




// MARK: - Welcome
//struct CartModel: Codable {
//    let statusCode: Int
//    let body: CartModelBody
//
//    enum CodingKeys: String, CodingKey {
//        case statusCode = "status_code"
//        case body
//    }
//}

// MARK: - Body
//struct CartModelBody: Codable {
//    let totalItemCount, totalPages: Int
//    let total: String
//    let response: [CartModelResponse]
//}

// MARK: - Response
class CartModelResponse: NSObject {
    var id : Int?
    var image = ""
    var title = ""
    var hasWishlist: Bool?
    var hasCartItem: Bool?
    var quantity: Int?
    var price = ""
    var sale_price = ""
    var discount = ""
    
    
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["id"] is NSNull)  && (dictionary["id"] != nil) {
            id = dictionary["id"] as? Int
        }
        if !(dictionary["title"] is NSNull)  && (dictionary["title"] != nil) {
            title = dictionary["title"] as! String
        }
        
        
        if !(dictionary["image"] is NSNull)  && (dictionary["image"] != nil) {
            image = dictionary["image"] as! String
        }
        if !(dictionary["price"] is NSNull)  && (dictionary["price"] != nil) {
            price = dictionary["price"] as! String
        }
        if !(dictionary["discount"] is NSNull)  && (dictionary["discount"] != nil) {
            discount = dictionary["discount"] as! String
        }
        
        if !(dictionary["hasWishlist"] is NSNull)  && (dictionary["hasWishlist"] != nil) {
            hasWishlist = dictionary["hasWishlist"] as? Bool
        }
        if !(dictionary["hasCartItem"] is NSNull)  && (dictionary["hasCartItem"] != nil) {
            hasCartItem = dictionary["hasCartItem"] as? Bool
        }
        if !(dictionary["quantity"] is NSNull)  && (dictionary["quantity"] != nil) {
            quantity = dictionary["quantity"] as? Int
        }
        if !(dictionary["sale_price"] is NSNull)  && (dictionary["sale_price"] != nil) {
            sale_price = dictionary["sale_price"] as! String
        }
    }
}
