//
//  MyReviewModel.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 13/03/2024.
//

import Foundation

// MARK: - Model
struct MyReviewModel: Codable {
    let statusCode: Int
    let body: MyReviewBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct MyReviewBody: Codable {
    let totalItemCount, totalPages: Int
    let response: [MyReviewResponse]
}

// MARK: - Response
struct MyReviewResponse: Codable {
    let id, productID, ownerID, rating: Int
    let review: String
    let recommend, status: Int
    let createdAt, updatedAt: String
    let owner: MyReviewOwner
    let product: MyReviewProduct

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case ownerID = "owner_id"
        case rating, review, recommend, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case owner, product
    }
}

// MARK: - Owner
struct MyReviewOwner: Codable {
    let id: Int
    let title: String
    let image, imageProfile, imageIcon: String

    enum CodingKeys: String, CodingKey {
        case id, title, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
    }
}

// MARK: - Product
struct MyReviewProduct: Codable {
    let id: Int
    let title, description, keywords: String
    let photoID, ownerID, categoryID, status: Int
    let price, salePrice: String
    let stock, viewCount, sellCount, brandID: Int
    let createdAt, updatedAt: String
    let featured, sponsored, newlabel, hotlabel: Int
    let salelabel, speciallabel: Int
    let sku: String
    let image, imageProfile, imageIcon: String

    enum CodingKeys: String, CodingKey {
        case id, title, description, keywords
        case photoID = "photo_id"
        case ownerID = "owner_id"
        case categoryID = "category_id"
        case status, price
        case salePrice = "sale_price"
        case stock
        case viewCount = "view_count"
        case sellCount = "sell_count"
        case brandID = "brand_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case featured, sponsored, newlabel, hotlabel, salelabel, speciallabel, sku, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
    }
}
