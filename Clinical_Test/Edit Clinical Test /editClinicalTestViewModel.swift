//
//  addPatientViewModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-23.
//

//
//  registrationViewModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-21.
//

import Foundation
import Combine
import SwiftUI

class EditClinicalTestViewModel: ObservableObject {
    @Published var respiratoryRate: String = ""
    @Published var bloodPressure: String = ""
    @Published var bloodOxygenLevel: String = ""
    @Published var heartbeatRate: String = ""
    @Published var chiefComplaint: String = ""
    @Published var pastMedicalHistory: String = ""
    @Published var medicalDiagnosis: String = ""
    @Published var medicalPrescription: String = ""
   
    @Published var isLoading: Bool = false
    @State var patientTestEditSuccess: Bool = false // Add this for tracking login success
    @Published var showToast: Bool = false // Control toast visibility
    
    @Published var respiratoryRateError: String?
    @Published var bloodPressureError: String?
    @Published var bloodOxygenLevelError: String?
    @Published var heartbeatRateError: String?
    @Published var chiefComplaintError: String?
    @Published var pastMedicalHistoryError: String?
    @Published var medicalDiagnosisError: String?
    @Published var medicalPrescriptionError: String?
    
    @Published var toastMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func clearField() {
        respiratoryRate = ""
        bloodPressure = ""
        bloodOxygenLevel = ""
        heartbeatRate = ""
        chiefComplaint = ""
        pastMedicalHistory = ""
        medicalDiagnosis = ""
        medicalPrescription = ""
        
    }
  
    func EditClinicalTest(clinicalTestId:String,patientId:String) {
        respiratoryRateError = nil
        bloodPressureError = nil
        bloodOxygenLevelError = nil
        heartbeatRateError = nil
        chiefComplaintError = nil
        pastMedicalHistoryError = nil
        medicalDiagnosisError = nil
        medicalPrescriptionError = nil

       
        guard !bloodPressure.isEmpty else {
            bloodPressureError = "Enter blood pressure"
            return
        }
        guard !respiratoryRate.isEmpty else {
            respiratoryRateError = "Enter respiratory rate"
            return
        }
        guard !bloodOxygenLevel.isEmpty else {
            bloodOxygenLevelError = "Enter blood oxygen level"
            return
        }
       
        guard !heartbeatRate.isEmpty else {
            heartbeatRateError = "Enter heartbeat rate"
            return
        }

        guard !chiefComplaint.isEmpty else {
            chiefComplaintError = "Enter chief complaint"
            return
        }
        guard !pastMedicalHistory.isEmpty else {
            pastMedicalHistoryError = "Enter past medical history"
            return
        }
        guard !medicalDiagnosis.isEmpty else {
            medicalDiagnosisError = "Enter medical diagnosis"
            return
        }
        guard !medicalPrescription.isEmpty else {
            medicalPrescriptionError = "Enter medical prescription"
            return
        }
        
        func getCurrentDateTimeISO8601() -> String {
            let dateFormatter = ISO8601DateFormatter()
            return dateFormatter.string(from: Date())
        }
        let currentDateTime = getCurrentDateTimeISO8601()
        isLoading = true
        let editTestData = [
            "bloodPressure": bloodPressure,
              "respiratoryRate": respiratoryRate,
              "bloodOxygenLevel": bloodOxygenLevel,
              "heartbeatRate": heartbeatRate,
              "chiefComplaint": chiefComplaint,
              "pastMedicalHistory": pastMedicalHistory,
              "medicalDiagnosis": medicalDiagnosis,
              "medicalPrescription": medicalPrescription,
              "creationDateTime": currentDateTime,
              "patientId": patientId
            
        ] as [String : Any]
        guard let url = URL(string: "https://group3-mapd713.onrender.com/api/clinical-tests/clinical-tests/\(clinicalTestId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: editTestData)
        } catch {
            print("Failed to encode JSON")
            return
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .decode(type: EditClinicalTestModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("patient Edit failed: \(error.localizedDescription)")
                case .finished:
                    print("patient Edit finished")
                }
                self.isLoading = false
            }, receiveValue: { editPatientResponse in
                self.isLoading = false
                if editPatientResponse.success! {
                    self.patientTestEditSuccess = true // Login successful
                    self.showToast = true
                    // Display a toast message for success and navigate to Home Screen
                    print("Edit Patient successful: \(editPatientResponse.message ?? "")")
                    self.toastMessage = "\(String(describing: editPatientResponse.message))"
                    // Navigate to home
                } else {
                    print("Edit Patient Unsuccessfull")
                    self.toastMessage = "\(String(describing: editPatientResponse.message))"
                }
            })
            .store(in: &cancellables)
    }
}
