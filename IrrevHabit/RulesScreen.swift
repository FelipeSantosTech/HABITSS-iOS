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
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("THE RULES")
                    .font(.headline)
                    .tracking(1)

                Group {
                    Text("• You may define up to 5 standards.")
                    Text("• Every day you either execute or miss.")
                    Text("• Misses are permanent and visible.")
                    Text("• Standards cannot be edited after locking.")
                    Text("• Consistency compounds over time.")
                }
                .foregroundColor(.gray)

                Button("I UNDERSTAND") {
                    onContinue()
                }
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .padding(.top, 24)
            }

            Spacer()
        }
    }
}
