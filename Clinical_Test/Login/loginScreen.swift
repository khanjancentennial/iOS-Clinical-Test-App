//
//  Login.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-20.
//

import SwiftUI

import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var emailFieldFocused: Bool
    @FocusState private var passwordFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 100)
                
                Text("Login!")
                    .font(.largeTitle)
                    .foregroundColor(.black)

                Spacer().frame(height: 40)
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Enter Email Id", text: $viewModel.email)
                        .focused($emailFieldFocused)
                        .keyboardType(.emailAddress)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let emailError = viewModel.emailError {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                HStack {
                    Image(systemName: "lock")
                    SecureField("Enter Password", text: $viewModel.password)
                        .focused($passwordFieldFocused)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Spacer().frame(height: 50)

                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 136/255, green: 8/255, blue: 8/255))
                            .cornerRadius(30)
                    }
                }

                Spacer().frame(height: 20)

                HStack {
                    Spacer()
                    Text("New User? ")
                    Button(action: {}) {
                        NavigationLink("Register Here", destination: RegistrationScreen())
                    }
                    .buttonStyle(PlainButtonStyle())
//                    NavigationLink("Register Here", destination: RegistrationScreen())
                }

                // Navigate to home screen after login success
                NavigationLink(destination: HomeScreen(), isActive: $viewModel.loginSuccess) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("")
            .navigationBarBackButtonHidden(true) // Hide the back button
            .navigationBarHidden(true)
            .onTapGesture {
                emailFieldFocused = false
                passwordFieldFocused = false
            }
            .overlay(toastView, alignment: .top) // Show toast message
        }
    }

    // Toast message view
    var toastView: some View {
        Group {
            if viewModel.showToast {
                Text(viewModel.loginSuccess ? "Login successful!" : "Please check your credentials!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(viewModel.loginSuccess ? Color.green : Color.red)
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                viewModel.dismissToast()
                            }
                        }
                    }
            }
        }
        .animation(.easeInOut, value: viewModel.showToast)
    }
}

// Preview in Xcode
struct PatientsLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

//// Preview in Xcode
//struct PatientsLoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginScreen()
//    }
//}
