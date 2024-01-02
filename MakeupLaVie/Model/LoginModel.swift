//
//  LoginModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 03/05/2023.


import Foundation


struct loginModel : Codable{
    let grant_type: String
    let client_id: String
    let client_secret: String
    let username: String
    let password: String
    let scope:String
}

// MARK: - Welcome
struct ResponseModel: Codable {
    let statusCode: Int
    let body: BodyA

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct BodyA: Codable {
    let tokenType: String
    let expiresIn: Int
    let accessToken, refreshToken: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

// MARK: - User
struct User: Codable {
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
