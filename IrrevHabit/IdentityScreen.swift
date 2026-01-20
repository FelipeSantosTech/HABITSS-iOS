//
//  IdentityScreen.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 20/01/26.
//

import SwiftUI

struct IdentityScreen: View {

    let onContinue: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 24) {
                Text("IRREV HABIT")
                    .font(.title)
                    .tracking(2)

                Text("""
This app is a contract with yourself.

You define your standards.
You execute daily.
Your actions compound.
""")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

                Button("CONTINUE") {
                    onContinue()
                }
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }

            Spacer()
        }
    }
}
