//
//  homeScreenViewModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-22.
//

import Foundation
import Combine
import SwiftUI


class HomeScreenViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var patients: [PatientData] = []
    
    private var cancellables = Set<AnyCancellable>()

    func fetchPatientData() {
        patients = []
        
        isLoading = true

        guard let url = URL(string: "https://group3-mapd713.onrender.com/patient/list") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Since this is a GET request, we don't need to set `httpBody`
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: AllPatientDetailsModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch patient data: \(error.localizedDescription)")
                case .finished:
                    print("Successfully fetched patient data")
                }
                self.isLoading = false
            }, receiveValue: { patientResponse in
                if let fetchedPatients = patientResponse.data {
                    self.patients = fetchedPatients
                } else {
                    print("No patients found")
                }
            })
            .store(in: &cancellables)
    }
}