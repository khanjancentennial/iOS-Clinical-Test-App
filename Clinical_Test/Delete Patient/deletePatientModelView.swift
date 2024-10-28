//
//  deletePatientModelView.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-27.
//

import Foundation
import Combine
import SwiftUI

class DeletePatientViewModel: ObservableObject {
//    @Published var patientId: String = ""
    @Published var isLoading: Bool = false
    @Published var patientDeleteSuccess: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func deletePatient(patientId: String,completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        guard let url = URL(string: "https://group3-mapd713.onrender.com/patient/delete/\(patientId)") else {
            isLoading = false
            toastMessage = "Invalid URL."
            showToast = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: DeletePatientsModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Patient delete failed: \(error.localizedDescription)")
                    self.toastMessage = "Failed to delete patient."
                case .finished:
                    break
                }
                self.isLoading = false
                self.showToast = true
            }, receiveValue: { apiResponse in
                self.patientDeleteSuccess = true
                self.toastMessage = apiResponse.message
                print("Delete Patient response: \(apiResponse.message)")
            })
            .store(in: &cancellables)
                let success = true // Determine if deletion was successful
                self.patientDeleteSuccess = success
                completion(success)
    }
}

