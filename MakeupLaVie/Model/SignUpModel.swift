//
//  SignUpModel.swift
//  MakeupLaVie


import Foundation

struct SignupModel : Codable {
    let first_name: String
    let last_name: String
    let email: String
    let phone: String
    let password: String
    let password_confirmation: String 
}
