//
//  loginModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-20.
//

import Foundation

struct LoginModel: Codable {
    var success: Bool
    var token: String?
    var user: User?

    struct User: Codable {
        var id: String
        var firstName: String
        var lastName: String
        var email: String
        var phoneNumber: String
        var gender: Int
        var healthcareProvider: Int

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case firstName, lastName, email, phoneNumber, gender, healthcareProvider
        }
    }
}
