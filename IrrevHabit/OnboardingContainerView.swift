//
//  OnboardingContainerView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 20/01/26.
//

import SwiftUI

struct OnboardingContainerView: View {

    @State private var step = 0
    @AppStorage("acceptedReality") private var acceptedReality = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch step {
            case 0:
                IdentityScreen {
                    step = 1
                }

            case 1:
                RulesScreen {
                    step = 2
                }

            default:
                CommitmentScreen {
                    acceptedReality = true
                }
            }
        }
        .font(.system(.body, design: .monospaced))
        .foregroundColor(.white)
        .padding(24)
    }
}


#Preview {
    OnboardingContainerView()
}
