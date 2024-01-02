//
//  UderInfoModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 04/05/2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let statusCode: Int
    let body: Body

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct Body: Codable {
    let id: Int
    let email, firstName, lastName, createdAt: String
    let updatedAt, locale: String
    let photoID, levelID, enabled, verified: Int
    let phone, cell, address1, address2: String
    let accountType: Int
    let countryID, stateID, cityID, lastloginIP: String
    let lastloginDate, creationIP, dob, emailVerifiedAt: String
    let gender: Int
    let username, stripeID, cardBrand, cardLastFour: String
    let trialEndsAt: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case locale
        case photoID = "photo_id"
        case levelID = "level_id"
        case enabled, verified, phone, cell, address1, address2
        case accountType = "account_type"
        case countryID = "country_id"
        case stateID = "state_id"
        case cityID = "city_id"
        case lastloginIP = "lastlogin_ip"
        case lastloginDate = "lastlogin_date"
        case creationIP = "creation_ip"
        case dob
        case emailVerifiedAt = "email_verified_at"
        case gender, username
        case stripeID = "stripe_id"
        case cardBrand = "card_brand"
        case cardLastFour = "card_last_four"
        case trialEndsAt = "trial_ends_at"
    }
}
