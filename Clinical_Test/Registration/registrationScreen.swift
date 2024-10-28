//
//  registrationScreen.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-20.
//


import SwiftUI

struct RegistrationScreen: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @FocusState private var firstNameFocused: Bool
    @FocusState private var lastNameFocused: Bool
    @FocusState private var phoneNumberFocused: Bool
    @FocusState private var emailFieldFocused: Bool
    @FocusState private var passwordFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
//                Spacer().frame(height: 100)
                
                Text("Registration!")
                    .font(.largeTitle)
                    .foregroundColor(.black)

                Spacer().frame(height: 40)
                
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter First Name ", text: $viewModel.firstName)
                        .focused($firstNameFocused)
                        .keyboardType(.default)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let firstNameError = viewModel.firstNameError {
                    Text(firstNameError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter Last Name ", text: $viewModel.lastName)
                        .focused($lastNameFocused)
                        .keyboardType(.default)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let lastNameError = viewModel.lastNameError {
                    Text(lastNameError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Enter Email Id", text: $viewModel.email)
                        .focused($emailFieldFocused)
                        .keyboardType(.emailAddress)
                        .onChange(of: viewModel.email, perform: { value in
                            viewModel.validateEmail()
                        })
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
                        .onChange(of: viewModel.password, perform: { value in
                            viewModel.validatePassword()
                        })
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "phone")
                    TextField("Enter Phone Number ", text: $viewModel.phoneNumber)
                        .focused($phoneNumberFocused)
                        .keyboardType(.phonePad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let phoneNumberError = viewModel.phoneNumberError {
                    Text(phoneNumberError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Text("Gender:")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading) // Aligns the content to the left
                    .padding(.leading, 20)
                HStack {
                            // Male selection
                            Button(action: {
                                viewModel.genderCheck("Male")
                            }) {
                                HStack {
                                    if viewModel.isMale {
                                        Circle()
                                            .fill(Color(red: 136/255, green: 8/255, blue: 8/255))
                                            .frame(width: 22, height: 22)
                                    } else {
                                        Circle()
                                            .fill(.black)
                                            .frame(width: 22, height: 22)
                                            .overlay(
                                                Circle()
                                                    .fill(.gray)
                                                    .frame(width: 20, height: 20)
                                            )
                                    }
                                    Text("Male")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.trailing, 20)

                            // Female selection
                            Button(action: {
                                viewModel.genderCheck("Female")
                            }) {
                                HStack {
                                    if viewModel.isFemale {
                                        Circle()
                                            .fill(Color(red: 136/255, green: 8/255, blue: 8/255))
                                            .frame(width: 22, height: 22)
                                    } else {
                                        Circle()
                                            .fill(.black)
                                            .frame(width: 22, height: 22)
                                            .overlay(
                                                Circle()
                                                    .fill(.gray)
                                                    .frame(width: 20, height: 20)
                                            )
                                    }
                                    Text("Female")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns the content to the left
                .padding(.leading, 20)
                if let genderError = viewModel.genderError {
                    Text(genderError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Text("Heathcare Type:")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading) // Aligns the content to the left
                    .padding(.leading, 20)
                HStack {
                            // Male selection
                            Button(action: {
                                viewModel.healthcareCheck("Doctor")
                            }) {
                                HStack {
                                    if viewModel.isDoctor {
                                        Circle()
                                            .fill(Color(red: 136/255, green: 8/255, blue: 8/255))
                                            .frame(width: 22, height: 22)
                                    } else {
                                        Circle()
                                            .fill(.black)
                                            .frame(width: 22, height: 22)
                                            .overlay(
                                                Circle()
                                                    .fill(.gray)
                                                    .frame(width: 20, height: 20)
                                            )
                                    }
                                    Text("Doctor")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.trailing, 20)

                            // Female selection
                            Button(action: {
                                viewModel.healthcareCheck("Nurse")
                            }) {
                                HStack {
                                    if viewModel.isNurse {
                                        Circle()
                                            .fill(Color(red: 136/255, green: 8/255, blue: 8/255))
                                            .frame(width: 22, height: 22)
                                    } else {
                                        Circle()
                                            .fill(.black)
                                            .frame(width: 22, height: 22)
                                            .overlay(
                                                Circle()
                                                    .fill(.gray)
                                                    .frame(width: 20, height: 20)
                                            )
                                    }
                                    Text("Nurse")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns the content to the left
                .padding(.leading, 20)

                Spacer().frame(height: 50)

                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    Button(action: {
                        viewModel.registreation()
                    }) {
                        Text("Register")
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
                    Text("Existing User? ")
                    NavigationLink("Login Here", destination: LoginScreen())
                }

                // Navigate to home screen after login success
                NavigationLink(destination: LoginScreen(), isActive: $viewModel.registrationSuccess) {
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
//            .overlay(toastView, alignment: .top) // Show toast message
        }
    }

    // Toast message view
    var toastView: some View {
        Group {
            if viewModel.showToast {
                Text("\(viewModel.toastMessage)" ?? "Registration Successful")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                viewModel.showToast = false
                            }
                        }
                    }
            }
            else{
                Text("\(viewModel.toastMessage)" ?? "Registration Failed")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                viewModel.showToast = false
                            }
                        }
                    }
            }
        }
        .animation(.easeInOut, value: viewModel.showToast)
    }
}
