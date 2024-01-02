//
//  GenericListingModel.swift
//  OnlineStore
//
//  Created by Musharraf on 05/11/2020.
//  Copyright © 2020 Musharraf. All rights reserved.
//

import UIKit

class GenericListingModel: NSObject {
    var id : Int?
    var image = ""
    var catagoryimage = ""
    var catagorylabel = ""
    var sale_price = ""
    var imageicon = ""
    var colorCat = ""
    var hasWishlist: Bool?
    var hasCartItem: Bool?
    
    //Recent product
    var price = ""
    // for ADD TO CART
    
    var descriptn = ""
    var sell_count = 0
    var discount = ""
    var thumb_main = ""
    var featured: Int?
    var sponsored: Int?
    var newLabel: Int?
    var hotLabel: Int?
    var saleLabel: Int?
    var specialLabel: Int?
    var rating: Double?
    //var Hot = ""
    
    
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["id"] is NSNull)  && (dictionary["id"] != nil) {
            id = dictionary["id"] as? Int
        }
        if !(dictionary["title"] is NSNull)  && (dictionary["title"] != nil) {
            catagorylabel = dictionary["title"] as! String
        }
        
        if !(dictionary["color"] is NSNull)  && (dictionary["color"] != nil) {
            colorCat = dictionary["color"] as! String
        }
        
        
        if !(dictionary["image_icon"] is NSNull)  && (dictionary["image_icon"] != nil) {
            imageicon = dictionary["image_icon"] as! String
        }
        
        
        if !(dictionary["image"] is NSNull)  && (dictionary["image"] != nil) {
            catagoryimage = dictionary["image"] as! String
        }
        if !(dictionary["price"] is NSNull)  && (dictionary["price"] != nil) {
            price = dictionary["price"] as! String
        }
        if !(dictionary["sale_price"] is NSNull)  && (dictionary["sale_price"] != nil) {
            sale_price = dictionary["sale_price"] as! String
        }
        if !(dictionary["description"] is NSNull)  && (dictionary["description"] != nil) {
            descriptn = dictionary["description"] as! String
        }
        if !(dictionary["discount"] is NSNull)  && (dictionary["discount"] != nil) {
            discount = dictionary["discount"] as! String
        }
        if !(dictionary["sell_count"] is NSNull)  && (dictionary["sell_count"] != nil) {
            sell_count = (dictionary["sell_count"] as? Int)!
        }
        if !(dictionary["thumb_main"] is NSNull)  && (dictionary["thumb_main"] != nil) {
            thumb_main = dictionary["thumb_main"] as! String
        }
        if !(dictionary["featured"] is NSNull)  && (dictionary["featured"] != nil) {
            featured = dictionary["featured"] as? Int
        }
        if !(dictionary["sponsored"] is NSNull)  && (dictionary["sponsored"] != nil) {
            sponsored = dictionary["sponsored"] as? Int
        }
        if !(dictionary["newlabel"] is NSNull)  && (dictionary["newlabel"] != nil) {
            newLabel = dictionary["newlabel"] as? Int
        }
        if !(dictionary["hotlabel"] is NSNull)  && (dictionary["hotlabel"] != nil) {
            hotLabel = dictionary["hotlabel"] as? Int
        }
        if !(dictionary["salelabel"] is NSNull)  && (dictionary["salelabel"] != nil) {
            saleLabel = dictionary["salelabel"] as? Int
        }
        if !(dictionary["speciallabel"] is NSNull)  && (dictionary["speciallabel"] != nil) {
            specialLabel = dictionary["speciallabel"] as? Int
        }
        if !(dictionary["hasWishlist"] is NSNull)  && (dictionary["hasWishlist"] != nil) {
            hasWishlist = dictionary["hasWishlist"] as? Bool
        }
        if !(dictionary["hasCartItem"] is NSNull)  && (dictionary["hasCartItem"] != nil) {
            hasCartItem = dictionary["hasCartItem"] as? Bool
        }
        if !(dictionary["rating"] is NSNull)  && (dictionary["rating"] != nil) {
            rating = (dictionary["rating"] as? Double)!
        }
        
        // trying for photos
        
        //        if !(dictionary["image"] is NSNull)  && (dictionary["image"] != nil) {
        //            image = dictionary["image"] as! String
        //        }
    }
}
