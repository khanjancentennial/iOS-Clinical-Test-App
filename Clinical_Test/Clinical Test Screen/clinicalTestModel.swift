//
//  homeScreenModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-22.
//

import Foundation

// Model class to represent the entire API response
struct ClinicalTestModel: Equatable, Decodable{
    let success: Bool
    let data: [PatientRecord]  // Array of PatientRecord to align with response
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
}

// Model class to represent each patient record
struct PatientRecord: Identifiable, Equatable, Decodable {
    let id: String
    let patient: Patient
    let bloodPressure: Int
    let respiratoryRate: Int
    let bloodOxygenLevel: Int
    let heartbeatRate: Int
    let chiefComplaint: String
    let pastMedicalHistory: String
    let medicalDiagnosis: String
    let medicalPrescription: String
    let creationDateTime: String
    let status: String
    let version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patient
        case bloodPressure
        case respiratoryRate
        case bloodOxygenLevel
        case heartbeatRate
        case chiefComplaint
        case pastMedicalHistory
        case medicalDiagnosis
        case medicalPrescription
        case creationDateTime
        case status
        case version = "__v"
    }
}

// Model class to represent the patient details
struct Patient: Identifiable, Codable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
    }
}
