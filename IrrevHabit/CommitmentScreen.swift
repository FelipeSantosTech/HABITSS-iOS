//
//  CommitmentScreen.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 20/01/26.
//

import SwiftUI

struct CommitmentScreen: View {

    let onAccept: () -> Void
    @State private var accepted = false

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 24) {
                Text("REALITY CHECK")
                    .font(.headline)
                    .tracking(1)

                Text("""
This system only works if you tell the truth.

If you fake execution, you are only lying to yourself.
""")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

                Toggle("I accept full responsibility for my actions.", isOn: $accepted)
                    .toggleStyle(SwitchToggleStyle(tint: .white))

                Button("ENTER") {
                    onAccept()
                }
                .disabled(!accepted)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(accepted ? Color.white : Color.gray)
                .padding(.top, 12)
            }

            Spacer()
        }
    }
}
