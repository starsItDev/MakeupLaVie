//
//  CategoriesModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 24/05/2023.
//

import Foundation

// MARK: - Welcome

class CategoryModel: NSObject {
    
    var id: Int?
    var title: String?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["id"] is NSNull)  && (dictionary["id"] != nil) {
            id = dictionary["id"] as? Int
        }
        if !(dictionary["title"] is NSNull)  && (dictionary["title"] != nil) {
            title = dictionary["title"] as? String
        }
    }
}
class SubCategoryModel: NSObject {
    
    var id: Int?
    var title: String?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        if !(dictionary["id"] is NSNull)  && (dictionary["id"] != nil) {
            id = dictionary["id"] as? Int
        }
        if !(dictionary["title"] is NSNull)  && (dictionary["title"] != nil) {
            title = dictionary["title"] as? String
        }
    }
}

struct CategoriesModel: Codable {
    let statusCode: Int
    let body: CategoriesBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct CategoriesBody: Codable {
    let totalItemCount, totalPages: Int
    let response: [Response]
}

// MARK: - Response
struct Response: Codable {
    let title: String
    let url: String
    let icon: JSONNull?
    let categories: [Category]
    let id: Int
    let image, imageProfile, imageIcon: String

    enum CodingKeys: String, CodingKey {
        case title, url, icon, categories, id, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
    }
}

// MARK: - Category
struct Category: Codable {
    let title: String
    let url: String
    let categories: [Category]?
    let id: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
