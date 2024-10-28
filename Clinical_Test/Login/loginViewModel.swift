//
//  loginViewModel.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-20.
//

import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var loginSuccess: Bool = false // Add this for tracking login success
    @State var showToast: Bool = false // Control toast visibility
    
    @Published var emailError: String?
    @Published var passwordError: String?
    
    private var cancellables = Set<AnyCancellable>()
    init() {
            checkIfLoggedIn()
        }
    func checkIfLoggedIn() {
           // Check if user is already logged in
           if UserDefaults.standard.bool(forKey: "isLoggedIn") {
               loginSuccess = true
           }
        else{
            loginSuccess = false
        }
       }
    
    func logOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        loginSuccess = false
    }
    
    func dismissToast() {
        showToast = false
    }
    func showSuccessToast() {
           showToast = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.dismissToast()
           }
       }

       func showFailureToast() {
           showToast = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.dismissToast()
           }
       }

    func login() {
        emailError = nil
        passwordError = nil

        guard !email.isEmpty else {
            emailError = "Enter Email ID"
            return
        }

        guard !password.isEmpty else {
            passwordError = "Enter Password"
            return
        }

        isLoading = true
        let loginData = [
            "email": email,
            "password": password
        ]

        guard let url = URL(string: "https://group3-mapd713.onrender.com/auth/login") else { return }
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
            .decode(type: LoginModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                case .finished:
                    print("Login finished")
                }
                self.isLoading = false
            }, receiveValue: { loginResponse in
                self.isLoading = false
                if loginResponse.success {
                    self.loginSuccess = true // Login successful
                    self.showToast = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")  // Store login state
                    // Display a toast message for success and navigate to Home Screen
                    print("Login successful, User: \(loginResponse.user?.firstName ?? "")")
                    self.showSuccessToast()
                    // Navigate to home
                } else {
                    print("Invalid credentials")

                    self.showFailureToast()                }
            })
            .store(in: &cancellables)
    }
}
