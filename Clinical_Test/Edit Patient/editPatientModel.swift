//
//  addPatientModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-23.
//

import Foundation

struct EditPatientModel: Hashable,Codable {
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
