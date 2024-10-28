//
//  registrationModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-21.
//

import Foundation

struct RegistrationModel: Codable {
    var success: Bool?
    var message: String?

    // Initializer
    init(success: Bool? = nil, message: String? = nil) {
        self.success = success
        self.message = message
    }

    // Custom CodingKeys if necessary
    private enum CodingKeys: String, CodingKey {
        case success
        case message
    }
}
