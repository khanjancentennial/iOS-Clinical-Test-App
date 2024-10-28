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

class EditPatientViewModel: ObservableObject {
    @Published var patientId: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var address: String = ""
   
    @Published var isLoading: Bool = false
    @Published var patientEditSuccess: Bool = false // Add this for tracking login success
    @Published var showToast: Bool = false // Control toast visibility
    
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var phoneNumberError: String?
    @Published var emailError: String?
    @Published var genderError: String?
    @Published var healthcareError: String?
    @Published var heightError: String?
    @Published var weightError: String?
    @Published var addressError: String?
    
    @Published var toastMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func clearField() {
        patientId = ""
        firstName = ""
        lastName = ""
        phoneNumber = ""
        email = ""
        height = ""
        weight = ""
        address = ""
        isMale = false
        isFemale = false
    }
    @Published var isMale = false
    @Published var isFemale = false

    func genderCheck(_ gender: String) {
        if gender == "Male" {
            isMale = true
            isFemale = false
        } else if gender == "Female" {
            isMale = false
            isFemale = true
        }
    }
    
    // Basic email and password validation
        func validateEmail() {
            let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailRegex = NSPredicate(format: "SELF MATCHES %@", emailPattern)
            emailError = emailRegex.evaluate(with: email) ? nil : "Invalid email format"
        }


    func EditPatient() {
        firstNameError = nil
        lastNameError = nil
        phoneNumberError = nil
        emailError = nil
        heightError = nil
        weightError = nil
        addressError = nil

        guard !firstName.isEmpty else {
            firstNameError = "Enter First Name"
            return
        }
        guard !lastName.isEmpty else {
            lastNameError = "Enter Last Name"
            return
        }
        if !phoneNumber.isEmpty{
            if phoneNumber.count != 10 {
                phoneNumberError = "Enter Valid Phone Number"
            }
            else{}
        } else {
            phoneNumberError = "Enter Phone Number"
            return
        }
//        guard phoneNumber.contains("@") else {
//            phoneNumberError = "Enter Phone Number"
//            return
//        }
        guard !email.isEmpty else {
            emailError = "Enter Email ID"
            return
        }

        guard !height.isEmpty else {
            heightError = "Enter Height"
            return
        }
        guard !weight.isEmpty else {
            weightError = "Enter Weight"
            return
        }
        guard !address.isEmpty else {
            addressError = "Enter Address"
            return
        }
        guard isMale || isFemale  else {
            genderError = "Select Gender"
            return
        }

        isLoading = true
        let editPatientData = [
            "firstName":firstName,
            "lastName":lastName,
            "phoneNumber": phoneNumber,
            "email": email,
            "height":height,
            "weight":weight,
            "gender":isMale ? 0 : 1,
            "address":address,
            "status": "normal"
            
        ] as [String : Any]

        guard let url = URL(string: "https://group3-mapd713.onrender.com/patient/patients/\(patientId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: editPatientData)
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
            .decode(type: EditPatientModel.self, decoder: JSONDecoder())
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
                    self.patientEditSuccess = true // Login successful
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
