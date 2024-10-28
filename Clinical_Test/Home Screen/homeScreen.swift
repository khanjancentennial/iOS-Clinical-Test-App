//
//  homeScreen.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-21.
//

import SwiftUI


// Main view to display the list of patients
// Main view to display the list of patients
struct HomeScreen: View {
    @StateObject private var viewModelLogin = LoginViewModel()
    @State private var searchText = ""
    @StateObject var viewModel = HomeScreenViewModel()
    @StateObject var deleteViewModel = DeletePatientViewModel()
    @State private var isEditActive = false
    @State private var isDeleteActive = false
    @State private var isDetailsActive = false
    @State private var selectedPatient: PatientData? = nil
    @State private var logoutTriggered = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color(red: 136/255, green: 8/255, blue: 8/255)
                    .ignoresSafeArea()

                VStack(alignment: .leading) {
                    headerView
                    patientListView
                }
                .padding()
            }
            .onAppear { viewModel.fetchPatientData()
                viewModelLogin.loginSuccess = true}
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $logoutTriggered) {
                            LoginScreen()
                        }
            
        }
    }

    // Separate header view
    private var headerView: some View {
        VStack(alignment: .leading) {
            HStack {
                searchTextField
                Spacer()
                logoutAccountButtons
            }
            .padding(.bottom, 10)

            HStack {
                Text("All Patients")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                NavigationLink(destination: AddPatientScreen()) {
                    addPatientButton
                }
            }
            .padding(.bottom, 10)
        }
    }

    private var searchTextField: some View {
        TextField("🔍 Search patients...", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.trailing, 20)
    }

    private var logoutAccountButtons: some View {
        HStack(spacing: 10) {
            Button(action: {
                viewModelLogin.logOut()
            }) {
                Image(systemName: "power.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
            }
            .buttonStyle(BorderlessButtonStyle())
            .onChange(of: viewModelLogin.loginSuccess) { loginSuccess in
                if !loginSuccess {
                    logoutTriggered = true
                }
            }
        }
    }


    private var addPatientButton: some View {
        HStack {
            Image(systemName: "plus.app.fill")
                .foregroundColor(Color(red: 136/255, green: 8/255, blue: 8/255))
                .font(.system(size: 40))
                .padding(.leading, 10)
            Text("Add")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 136/255, green: 8/255, blue: 8/255))
                .padding(.trailing, 20)
        }
        .background(Color.white)
        .cornerRadius(10)
    }

    private var patientListView: some View {
        List {
            ForEach(filteredPatients) { patient in
                patientRow(patient)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
        .cornerRadius(20)
    }

    private func patientRow(_ patient: PatientData) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(patient.firstName) \(patient.lastName)")
                    .font(.headline)
                Text("Height: \(patient.height)")
                    .font(.subheadline)
                Text("Weight: \(patient.weight)")
                    .font(.subheadline)
                Text("Gender: \(patient.gender == 0 ? "Male" : "Female")")
                    .font(.subheadline)
                Text("Status: \(patient.status)")
                    .font(.subheadline)
                    .foregroundColor(patient.status == "critical" ? .red : .green)
                    .fontWeight(patient.status == "critical" ? .bold : .medium)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)

            Spacer()
            editButton(patient)
            deleteButton(patient)
            detailsButton(patient)
        }
        .padding(.horizontal, 10)
    }
    
    // Define isEditActiveBinding as a Binding<Bool>
    
    private func editButton(_ patient: PatientData) -> some View {
        
        // Define the binding property inside the function
            let isEditActiveBinding = Binding<Bool>(
                get: {
                    isEditActive && selectedPatient == patient
                },
                set: { newValue in
                    isEditActive = newValue
                    if !newValue {
                        selectedPatient = nil
                    }
                }
            )
        
        return Button(action: {
            isEditActive = true
            isDeleteActive = false
            isDetailsActive = false
            selectedPatient = patient
        })
        {
            
            NavigationLink(destination: EditPatientScreen(
                patientID: patient._id,
                firstName: patient.firstName,
                lastName: patient.lastName,
                email: patient.email,
                phoneNumber: patient.phoneNumber,
                weight: patient.weight,
                height: patient.height,
                address: patient.address,
                gender: patient.gender
            ),isActive: isEditActiveBinding
                
            ) {
                Image(systemName: "pencil.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
            }
            .foregroundColor(.clear)
            .frame(width: 30, height: 30)
        }
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 30, height: 30)
    }
    private func deleteButton(_ patient: PatientData) -> some View {
        Button(action: {
            selectedPatient = patient
            isDeleteActive = true
            isEditActive = false
            isDetailsActive = false
        }) {
            Image(systemName: "trash")
                .font(.system(size: 30))
                .foregroundColor(.red)
        }
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 30, height: 30)
        .padding(.trailing, 10)
        .alert(isPresented: $isDeleteActive) {
            Alert(
                title: Text("Delete Patient"),
                message: Text("Are you sure you want to delete \(selectedPatient?.firstName ?? "") \(selectedPatient?.lastName ?? "")?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let patientID = selectedPatient?._id {
                        deleteViewModel.deletePatient(patientId: patientID)
                        { success in
                            if success {
                            // Refresh the patient data
                                viewModel.patients = []
                                viewModel.fetchPatientData()
                            }
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    private func detailsButton(_ patient: PatientData) -> some View {
        
        
        // Define the binding property inside the function
            let isDetailsActiveBinding = Binding<Bool>(
                get: {
                    isDetailsActive && selectedPatient == patient
                },
                set: { newValue in
                    isDetailsActive = newValue
                    if !newValue {
                        selectedPatient = nil
                    }
                }
            )
        
       return Button(action: {
            isEditActive = false
            isDeleteActive = false
            isDetailsActive = true
            selectedPatient = patient
        })
        {
            NavigationLink(destination: ClinicalTestScreen(
                patientID: patient._id,
                firstName: patient.firstName,
                lastName: patient.lastName
            ),isActive: isDetailsActiveBinding
            ) {
                Image(systemName: "arrowshape.right.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
            .foregroundColor(.clear)
            .frame(width: 30, height: 30)
        }
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 30, height: 30)
        .padding(.leading, 10)
    }
    
    private var filteredPatients: [PatientData] {
        if searchText.isEmpty {
            return viewModel.patients
        } else {
            return viewModel.patients.filter { patient in
                patient.firstName.localizedCaseInsensitiveContains(searchText) ||
                patient.lastName.localizedCaseInsensitiveContains(searchText) ||
                patient.status.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

// Preview in Xcode
struct PatientsListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

