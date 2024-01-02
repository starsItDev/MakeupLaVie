//
//  SecondBrowseProductModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 13/06/2023.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SecondBrowseProductModel: Codable {
    let statusCode: Int
    let body: SecondBrowseProductModelBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct SecondBrowseProductModelBody: Codable {
    let totalItemCount, totalPages: Int
    let response: [SecondBrowseProductModelResponse]
}

// MARK: - Response
struct SecondBrowseProductModelResponse: Codable {
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
