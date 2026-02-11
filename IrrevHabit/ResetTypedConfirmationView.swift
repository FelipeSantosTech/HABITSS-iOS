//
//  ResetTypedConfirmationView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 11/02/26.
//


import SwiftUI

struct ResetTypedConfirmationView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var input = ""

    let onConfirm: () -> Void

    private var isValid: Bool {
        input.uppercased() == "RESET"
    }

    var body: some View {
        VStack(spacing: 28) {

            VStack(spacing: 12) {

                Text("Final Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Type RESET to permanently delete all discipline data.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            TextField("Type RESET", text: $input)
                .textInputAutocapitalization(.characters)
                .padding()
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.6))
                )
                .foregroundColor(.white)

            Button {
                onConfirm()
                dismiss()
            } label: {
                Text("Permanently Reset")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .background(isValid ? Color.red : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .disabled(!isValid)

            
            // 👇 Close button (intentional + low visual weight)
            Button {
                dismiss()
            } label: {
                Text("Close")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(28)
        .background(Color.black.ignoresSafeArea())
    }
}
