//
//  homeScreen.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-21.
//

import SwiftUI


// Main view to display the list of patients
// Main view to display the list of patients
struct ClinicalTestScreen: View {
    @State var patientID: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var searchText = ""
    @StateObject var viewModel = ClinicalTestViewModel()
    @StateObject var deleteViewModel = DeleteClinicalTestViewModel()
    @State private var isEditActive = false
    @State private var isDeleteActive = false
    @State private var isDetailsActive = false
    @State private var selectedPatient: PatientRecord? = nil

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
                let backButtonColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                        UINavigationBar.appearance().tintColor = backButtonColor}
            .navigationBarTitle("")
            .accentColor(Color(red: 255/255, green: 255/255, blue: 255/255))
            //            .navigationBarHidden(true)
           
        }
    }

    // Separate header view
    private var headerView: some View {
        VStack(alignment: .leading) {
            VStack{
                Text("Welcome, \(firstName) \(lastName)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
            }

            HStack {
                Text("Clinical Tests")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                NavigationLink(destination: AddClinicalTestScreen(
                    patientId: patientID,
                    firstName: firstName,
                    lastName: lastName
                )) {
                    addPatientButton
                }
            }
            .padding(.bottom, 10)
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
            if filteredPatients.isEmpty {
                        Text("No Tests available.")
                            .font(.headline)
                            .foregroundColor(.red)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(filteredPatients) { patient in
                            patientRow(patient)
                        }
                    }
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
        .cornerRadius(20)
    }

    private func patientRow(_ patient: PatientRecord) -> some View {
        VStack{
            if patient.patient.id == patientID {
                
                if viewModel.patients.isEmpty {
                    HStack(alignment: .center) {
                        Text("No data available")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                                    
                }else{
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(patient.creationDateTime)")
                                .font(.headline)
                            Text("bloodPressure: \(patient.bloodPressure)")
                                .font(.subheadline)
                            Text("bloodOxygenLevel: \(patient.bloodOxygenLevel)")
                                .font(.subheadline)
                            Text("respiratoryRate: \(patient.respiratoryRate)")
                                .font(.subheadline)
                            Text("heartbeatRate: \(patient.heartbeatRate)")
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
            //            detailsButton(patient)
                    }
                    .padding(.horizontal, 10)
                }
            }else{
                EmptyView()
            }
        }
        
    }

    private func editButton(_ patient: PatientRecord) -> some View {
        Button(action: {
            isEditActive = true
            selectedPatient = patient
        })
        {
            NavigationLink(destination: EditClinicalTestScreen(
                patientId: patientID,
                testId: patient.id,
                firstName: patient.patient.firstName,
                lastName: patient.patient.lastName,
                bloodPressure: String(patient.bloodPressure),
                respiratoryRate: String(patient.respiratoryRate),
                heartbeatRate: String(patient.heartbeatRate),
                bloodOxygenLevel: String(patient.bloodOxygenLevel),
                chiefComplaint: patient.chiefComplaint,
                pastMedicalHistory: patient.pastMedicalHistory,
                medicalDiagnosis: patient.medicalDiagnosis,
                medicalPrescription: patient.medicalPrescription
            ),isActive: .constant(selectedPatient == patient)
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
    private func deleteButton(_ patient: PatientRecord) -> some View {
        Button(action: {
            selectedPatient = patient
            isDeleteActive = true
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
                title: Text("Delete Clinical Test"),
                message: Text("Are you sure you want to delete the test record for \(selectedPatient?.patient.firstName ?? "") \(selectedPatient?.patient.lastName ?? "")?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let testId = selectedPatient?.id {
                        deleteViewModel.deletePatient(testId: testId)
                        { success in
                            if success {
                            // Refresh the patient data
                                viewModel.patients = []
                                selectedPatient = nil
                                viewModel.fetchPatientData()
                            }
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var filteredPatients: [PatientRecord] {
        // Filter patients based on the patientID
        if searchText.isEmpty {
            return viewModel.patients.filter { $0.patient.id == patientID }
        } else {
            return viewModel.patients.filter { patient in
                patient.patient.id == patientID && (
                    patient.patient.firstName.localizedCaseInsensitiveContains(searchText) ||
                    patient.patient.lastName.localizedCaseInsensitiveContains(searchText) ||
                    patient.status.localizedCaseInsensitiveContains(searchText)
                )
            }
        }
    }
}

// Preview in Xcode
struct ClinicalTestScreen_Previews: PreviewProvider {
    static var previews: some View {
        ClinicalTestScreen()
    }
}

