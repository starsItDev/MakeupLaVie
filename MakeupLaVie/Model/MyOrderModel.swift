//
//  MyOrderModel.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 11/01/2024.
//

import Foundation

// MARK: - Welcome
struct MyOrderModel: Codable {
    let statusCode: Int
    let body: MyOrderBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct MyOrderBody: Codable {
    let totalItemCount, totalPages: Int
    let response: [MyOrderResponse]
}

// MARK: - Response
struct MyOrderResponse: Codable {
    let id, ownerID, itemCount, subTotal: Int
    let shippingPrice, tax, grandTotal, gatewayID: Int
    let orderNote: String
    let shippingAddress, billingAddress: Int
    let status, createdAt, updatedAt, adminNotes: String
    let products: [MyOrderProduct]

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case itemCount = "item_count"
        case subTotal = "sub_total"
        case shippingPrice = "shipping_price"
        case tax
        case grandTotal = "grand_total"
        case gatewayID = "gateway_id"
        case orderNote = "order_note"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminNotes = "admin_notes"
        case products
    }
}

// MARK: - Product
struct MyOrderProduct: Codable {
    let title: String
    let quantity: Int
    let price: String
    let image, imageProfile, imageIcon: String

    enum CodingKeys: String, CodingKey {
        case title, quantity, price, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
    }
}
