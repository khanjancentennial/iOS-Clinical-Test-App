//
//  homeScreenModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-22.
//

import Foundation

import Foundation

// Root model for the API response
struct AllPatientDetailsModel: Codable {
    let success: Bool
    let data: [PatientData]?
}

// Model for individual patient data
struct PatientData: Codable, Identifiable,Hashable {
    var id: String { _id } // Converting "_id" to "id"
    let _id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let weight: String
    let height: String
    let address: String
    let gender: Int
    let status: String
}
