//
//  RulesScreen.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 20/01/26.
//

import SwiftUI

struct RulesScreen: View {

    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 24) {

                    VStack(spacing: 12) {
                        Text("EVERY DAY YOU EXECUTE OR MISS")
                        Text("MISSES ARE PERMANENT")
                        Text("CONSISTENCY COMPOUNDS")
                    }

                    Text("READ THIS CAREFULLY.")
                        .font(.headline)

                    Button("I UNDERSTAND") {
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
