//
//  DangerZoneCardView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 11/02/26.
//


import SwiftUI

struct DangerZoneCardView: View {

    @EnvironmentObject var proManager: ProManager
    @EnvironmentObject var standardsStore: StandardsStore

    @State private var showPaywall = false
    @State private var showResetAlert = false
    @State private var showTypedReset = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Reset Discipline Data")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Text("Clears standards, history, and progress.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))

            Divider()
                .overlay(Color.red.opacity(0.4))
                .padding(.vertical, 4)

            Button {
                handleResetTapped()
            } label: {
                Text("Reset Everything")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .foregroundColor(.white)
            .background(Color.red.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 12))

        }
        .padding(18)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.cardBorderDanger, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))

        // PAYWALL
        .sheet(isPresented: $showPaywall) {
            PaywallTimelineView()
                .environmentObject(proManager)
        }
        .sheet(isPresented: $showTypedReset) {
            ResetTypedConfirmationView {
                standardsStore.resetAllData()
            }
        }


        // CONFIRM RESET ALERT
        .alert(
            "Reset Everything?",
            isPresented: $showResetAlert
        ) {
            Button("Cancel", role: .cancel) {}

            Button("Continue", role: .destructive) {
                showTypedReset = true
            }

        } message: {
            Text("This will permanently delete all standards and history.")
        }
    }

    // MARK: Logic

    private func handleResetTapped() {
        if proManager.isProUser {
            showResetAlert = true
        } else {
            showPaywall = true
        }
    }
}

