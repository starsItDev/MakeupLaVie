//
//  ProductReviewModel.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 13/03/2024.
//

//import Foundation
//
//// MARK: - Model
//struct ReviewModel: Codable {
//    let statusCode: Int
//    let body: ReviewBody
//
//    enum CodingKeys: String, CodingKey {
//        case statusCode = "status_code"
//        case body
//    }
//}
//
//// MARK: - Body
//struct ReviewBody: Codable {
//    let totalItemCount, rating: Int
//    let reviewStats: [String: Int]
//    let totalPages: Int
//    let response: [ReviewResponse]
//}
//
//// MARK: - Response
//struct ReviewResponse: Codable {
//    let id, productID, ownerID, rating: Int
//    let review: String
//    let recommend, status: Int
//    let createdAt, updatedAt: String
//    let owner: Owner
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case ownerID = "owner_id"
//        case rating = "rating"
//        case review = "review"
//        case recommend, status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case owner
//    }
//}
//
//// MARK: - Owner
//struct Owner: Codable {
//    let id: Int
//    let title: String
//    let image, imageProfile, imageIcon: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case title = "title"
//        case image = "image"
//        case imageProfile = "image_profile"
//        case imageIcon = "image_icon"
//    }
//}



import Foundation

// MARK: - Model
struct ReviewModel: Codable {
    let statusCode: Int
    let body: ReviewBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct ReviewBody: Codable {
    let totalItemCount: Int
    let rating: Double
    let reviewStats: [String: Double]
    let totalPages: Int
    let response: [ReviewResponse]
}

// MARK: - Response
struct ReviewResponse: Codable {
    let id, productID, ownerID, rating: Int
    let review: String
    let recommend, status: Int
    let createdAt, updatedAt: String
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case ownerID = "owner_id"
        case rating, review, recommend, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case owner
    }
}

// MARK: - Owner
struct Owner: Codable {
    let id: Int
    let title: String
    let image, imageProfile, imageIcon: String

    enum CodingKeys: String, CodingKey {
        case id, title, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
    }
}
