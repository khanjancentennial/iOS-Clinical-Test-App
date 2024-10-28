//
//  deletePatientScreen.swift
//  Clinical_Test
//
//  Created by Khanjan Dave on 2024-10-27.
//


import SwiftUI

struct DeletePatientScreen: View {
    @Binding var isDeleteActive: Bool
    var patient: PatientData
    var onConfirmDelete: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Delete Patient")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("Are you sure you want to delete \(patient.firstName) \(patient.lastName)? This action cannot be undone.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            HStack(spacing: 20) {
                // "No" Button
                Button(action: {
                    isDeleteActive = false // Close dialog on "No"
                }) {
                    Text("No")
                        .font(.title3)
                        .bold()
                        .frame(minWidth: 80)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(8)
                }

                // "Yes" Button
                Button(action: {
                    onConfirmDelete()
                    isDeleteActive = false // Close dialog after deleting
                }) {
                    Text("Yes")
                        .font(.title3)
                        .bold()
                        .frame(minWidth: 80)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
