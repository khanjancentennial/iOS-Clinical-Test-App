//
//  registrationViewModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-21.
//

import Foundation
import Combine
import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var registrationSuccess: Bool = false // Add this for tracking login success
    @Published var showToast: Bool = false // Control toast visibility
    
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var phoneNumberError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var genderError: String?
    @Published var healthcareError: String?
    
    @Published var toastMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    @Published var isMale = false
    @Published var isFemale = false
    @Published var isDoctor = false
    @Published var isNurse = false

    func genderCheck(_ gender: String) {
        if gender == "Male" {
            isMale = true
            isFemale = false
        } else if gender == "Female" {
            isMale = false
            isFemale = true
        }
    }
    func healthcareCheck(_ gender: String) {
        if gender == "Doctor" {
            isDoctor = true
            isNurse = false
        } else if gender == "Nurse" {
            isDoctor = false
            isNurse = true
        }
    }
    // Basic email and password validation
        func validateEmail() {
            let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailRegex = NSPredicate(format: "SELF MATCHES %@", emailPattern)
            emailError = emailRegex.evaluate(with: email) ? nil : "Invalid email format"
        }

        func validatePassword() {
            let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+])[A-Za-z\\d!@#$%^&*()_+]{8,}$"
            let passwordRegex = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
            passwordError = passwordRegex.evaluate(with: password) ? nil : "Password must contain at least one letter, number, and special character"
        }

    func registreation() {
        firstNameError = nil
        lastNameError = nil
        phoneNumberError = nil
        emailError = nil
        passwordError = nil

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

        guard !password.isEmpty else {
            passwordError = "Enter Password"
            return
        }
        
        guard isMale || isFemale  else {
            genderError = "Select Gender"
            return
        }
        guard isDoctor || isNurse  else {
            healthcareError = "Select Healthcare Type"
            return
        }

        isLoading = true
        let loginData = [
            "firstName":firstName,
            "lastName":lastName,
            "phoneNumber": phoneNumber,
            "email": email,
            "password": password,
            "gender":isMale ? "0":"1",
            "healthcareProvider": isDoctor ? "0" : "1"
         ]

        guard let url = URL(string: "https://group3-mapd713.onrender.com/auth/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData)
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
            .decode(type: RegistrationModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("registration failed: \(error.localizedDescription)")
                case .finished:
                    print("registration finished")
                }
                self.isLoading = false
            }, receiveValue: { registrationResponse in
                self.isLoading = false
                if registrationResponse.success! {
                    self.registrationSuccess = true // Login successful
                    self.showToast = true
                    // Display a toast message for success and navigate to Home Screen
                    print("Login successful, User: \(registrationResponse.message ?? "")")
                    self.toastMessage = "\(String(describing: registrationResponse.message))"
                    // Navigate to home
                } else {
                    print("Invalid credentials")
                    self.toastMessage = "\(String(describing: registrationResponse.message))"
                }
            })
            .store(in: &cancellables)
    }
}
