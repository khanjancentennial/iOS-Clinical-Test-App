//
//  addPatientScreen.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-22.
//

import SwiftUI

struct EditClinicalTestScreen: View {
    @State var patientId: String?
    @State var testId: String?
    @State var firstName: String?
    @State var lastName: String?
    @State var bloodPressure: String?
    @State var respiratoryRate: String?
    @State var heartbeatRate: String?
    @State var bloodOxygenLevel: String?
    @State var chiefComplaint: String?
    @State var pastMedicalHistory: String?
    @State var medicalDiagnosis: String?
    @State var medicalPrescription: String?
   
    
    // Add any properties you need here
    @StateObject private var viewModel = EditClinicalTestViewModel()
    @FocusState private var bloodPressureFocused: Bool
    @FocusState private var respiratoryRateFocused: Bool
    @FocusState private var heartbeatRateFocused: Bool
    @FocusState private var bloodOxygenLevelFocused: Bool
    @FocusState private var chiefComplaintFocused: Bool
    @FocusState private var pastMedicalHistoryFocused: Bool
    @FocusState private var medicalDiagnosisFocused: Bool
    @FocusState private var medicalPrescriptionFocused: Bool
    
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
                    TextField("Enter BloodPressure ", text: $viewModel.bloodPressure)
                        .focused($bloodPressureFocused)
                        .keyboardType(.default)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let bloodPressureError = viewModel.bloodPressureError {
                    Text(bloodPressureError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter respiratoryRate ", text: $viewModel.respiratoryRate)
                        .focused($respiratoryRateFocused)
                        .keyboardType(.default)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let respiratoryRateError = viewModel.respiratoryRateError {
                    Text(respiratoryRateError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Enter bloodOxygenLevel", text: $viewModel.bloodOxygenLevel)
                        .focused($bloodOxygenLevelFocused)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let bloodOxygenLevelError = viewModel.bloodOxygenLevelError {
                    Text(bloodOxygenLevelError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter heartbeatRate ",
                              text: $viewModel.heartbeatRate)
                        .focused($heartbeatRateFocused)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let heartbeatRateError = viewModel.heartbeatRateError {
                    Text(heartbeatRateError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter chiefComplaint",
                              text: $viewModel.chiefComplaint)
                        .focused($chiefComplaintFocused)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let chiefComplaintError = viewModel.chiefComplaintError {
                    Text(chiefComplaintError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter pastMedicalHistory",
                              text: $viewModel.pastMedicalHistory)
                        .focused($pastMedicalHistoryFocused)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let pastMedicalHistoryError = viewModel.pastMedicalHistoryError {
                    Text(pastMedicalHistoryError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter medicalDiagnosis",
                              text: $viewModel.medicalDiagnosis)
                        .focused($medicalDiagnosisFocused)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let medicalDiagnosisError = viewModel.medicalDiagnosisError {
                    Text(medicalDiagnosisError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                    TextField("Enter medicalPrescription ",
                              text: $viewModel.medicalPrescription)
                        .focused($medicalPrescriptionFocused)
                        .keyboardType(.default)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)

                if let medicalPrescriptionError = viewModel.medicalPrescriptionError {
                    Text(medicalPrescriptionError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                
                
                
                
                Spacer().frame(height: 50)
                
                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    Button(action: {
                        viewModel.EditClinicalTest(clinicalTestId: testId!, patientId: patientId!)
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
                NavigationLink(destination: ClinicalTestScreen(
                    patientID: patientId!,
                    firstName: firstName!,
                    lastName: lastName!
                ), isActive: $viewModel.patientTestEditSuccess)
                {
                    EmptyView()
                   
                }
                .onDisappear {
                    
                    if viewModel.patientTestEditSuccess {
                        patientId = ""
                        testId = ""
                        // Reset fields when navigating to the home screen
                        bloodPressure = ""
                        respiratoryRate = ""
                        heartbeatRate = ""
                        bloodOxygenLevel = ""
                        chiefComplaint = ""
                        pastMedicalHistory = ""
                        medicalDiagnosis = ""
                        medicalPrescription = ""
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
                bloodPressureFocused = false
                respiratoryRateFocused = false
                heartbeatRateFocused = false
                bloodOxygenLevelFocused = false
                chiefComplaintFocused = false
                pastMedicalHistoryFocused = false
                medicalDiagnosisFocused = false
                medicalPrescriptionFocused = false
            }
            
//            .overlay(toastView, alignment: .top) // Show toast message
            .onAppear {
                print("Patient ID: \(patientId)")
                viewModel.bloodPressure = bloodPressure!
                viewModel.respiratoryRate = respiratoryRate!
                viewModel.heartbeatRate = heartbeatRate!
                viewModel.bloodOxygenLevel =  bloodOxygenLevel!
                viewModel.chiefComplaint = chiefComplaint!
                viewModel.pastMedicalHistory = pastMedicalHistory!
                viewModel.medicalDiagnosis = medicalDiagnosis!
                viewModel.medicalPrescription =  medicalPrescription!
                
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
struct EditClinicalTestScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditClinicalTestScreen()
    }
}

