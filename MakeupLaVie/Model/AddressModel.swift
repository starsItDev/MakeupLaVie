//
//  AddressModel.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 19/01/2024.
//

import Foundation

// MARK: - Address Model
struct AddressResponse: Codable {
    let statusCode: Int
    let body: [Address]
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct Address: Codable {
    let id: Int
    let ownerID: Int
    let type: String
    let firstName: String
    let lastName: String
    let phone: String
    let address1: String
    let address2: String
    let country: String
    let state: String
    let city: String
    let zip: String
    let isDefault: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case type
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case address1 = "address_1"
        case address2 = "address_2"
        case country, state, city, zip
        case isDefault = "default"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
