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
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 24) {

                    VStack(spacing: 12) {
                        Text("HABITSS DOES NOT MOTIVATE YOU")
                        Text("IT RECORDS WHAT YOU ACTUALLY DO")
                        Text("MISSES ARE PERMANENT")
                    }

                    Text("THIS IS A CONTRACT WITH YOURSELF.")
                        .font(.headline)

                    Button("CONTINUE") {
                        onContinue()
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

