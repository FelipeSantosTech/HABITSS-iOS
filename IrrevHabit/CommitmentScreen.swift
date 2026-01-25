//
//  CommitmentScreen.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 20/01/26.
//

import SwiftUI

struct CommitmentScreen: View {

    let onAccept: () -> Void
    @State private var rejected = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 24) {

                    Text("ARE YOU READY TO SEE THE TRUTH AND CHANGE YOUR REALITY?")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {

                        Button("YES") {
                            onAccept()
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(8)

                        Button("NO") {
                            rejected = true
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .font(.footnote)
                        .tracking(1)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }

                    if rejected {
                        Text("THEN THIS APP IS NOT FOR YOU.")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.top, 8)
                    }
                }

                Spacer()
            }
            .padding(24)
        }
    }
}
