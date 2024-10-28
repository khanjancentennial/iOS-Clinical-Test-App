//
//  addPatientScreen.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-22.
//

import SwiftUI

struct EditPatientScreen: View {
    @State var patientID: String?
    @State var firstName: String?
    @State var lastName: String?
    @State var email: String?
    @State var phoneNumber: String?
    @State var weight: String?
    @State var height: String?
    @State var address: String?
    @State var gender: Int?
    
    // Add any properties you need here
    @StateObject private var viewModel = EditPatientViewModel()
    @FocusState private var firstNameFocused: Bool
    @FocusState private var lastNameFocused: Bool
    @FocusState private var phoneNumberFocused: Bool
    @FocusState private var emailFieldFocused: Bool
    @FocusState private var heightFocused: Bool
    @FocusState private var weightFocused: Bool
    @FocusState private var addressFocused: Bool
    
    var body: some View {
        // Your view content here
        NavigationStack {
            VStack {
                //                Spacer().frame(height: 10)
                
                Text("Edit Patient Details!")
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
                
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter Weight ",
                              text: $viewModel.weight)
                    .focused($weightFocused)
                    .keyboardType(.numberPad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)
                
                if let weightError = viewModel.weightError {
                    Text(weightError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter Height ",
                              text: $viewModel.height)
                    .focused($heightFocused)
                    .keyboardType(.numberPad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)
                
                if let heightError = viewModel.heightError {
                    Text(heightError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter Address ",
                              text: $viewModel.address)
                    .focused($addressFocused)
                    .keyboardType(.default)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)
                
                if let addressError = viewModel.addressError {
                    Text(addressError)
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
                
                
                
                Spacer().frame(height: 50)
                
                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    Button(action: {
                        viewModel.EditPatient()
                    }) {
                        Text("Edit Patient Details")
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 136/255, green: 8/255, blue: 8/255))
                            .cornerRadius(30)
                    }
                }
                
                Spacer().frame(height: 20)
                
                
                //                 Navigate to home screen after login success
                NavigationLink(destination: HomeScreen(), isActive: $viewModel.patientEditSuccess)
                {
                    EmptyView()
                   
                }
                .onDisappear {
                    
                    if viewModel.patientEditSuccess {
                        patientID = ""
                        // Reset fields when navigating to the home screen
                        firstName = ""
                        lastName = ""
                        email = ""
                        phoneNumber = ""
                        weight = ""
                        height = ""
                        address = ""
                        viewModel.clearField()
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .navigationTitle("")
//            .navigationBarBackButtonHidden(true) // Hide the back button
//            .navigationBarHidden(true)
            .onTapGesture {
                emailFieldFocused = false
                firstNameFocused = false
                lastNameFocused = false
                phoneNumberFocused = false
                heightFocused = false
                weightFocused = false
                addressFocused = false
            }
            
//            .overlay(toastView, alignment: .top) // Show toast message
            .onAppear {
                print("Patient ID: \(patientID)")
                viewModel.patientId = patientID!
                viewModel.firstName = firstName!
                viewModel.lastName = lastName!
                viewModel.email = email!
                viewModel.phoneNumber = phoneNumber!
                viewModel.weight = weight!
                viewModel.height = height!
                viewModel.address = address!
                viewModel.genderCheck(gender == 0 ? "Male" : "Female")
                            }
        }
    }
    var toastView: some View {
        Group {
            if viewModel.showToast {
                Text("\(viewModel.toastMessage)" ?? "Patient Details Edited Successfully")
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
                Text("\(viewModel.toastMessage)" ?? "Patient Details Edited Successfully")
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

// This is needed for preview
struct EditPatientScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditPatientScreen()
    }
}

