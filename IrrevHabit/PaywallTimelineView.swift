//
//  PaywallTimelineView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 06/02/26.
//

import SwiftUI

struct PaywallTimelineView: View {
    enum PlanType {
        case monthly
        case annual
    }

    @State private var selectedPlan: PlanType = .monthly
    @State private var trialEnabled: Bool = false   //  Default OFF (philosophy)
    @Environment(\.dismiss) private var dismiss
    private let today = Date()
    private var reminderDate: Date {
        Calendar.current.date(byAdding: .day, value: 4, to: today)!
    }
    private var activationDate: Date {
        Calendar.current.date(byAdding: .day, value: 7, to: today)!
    }

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {


                Spacer()
                VStack(spacing: 5) {

                    Text("How free trial works")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)


                    Text("You won't be charged anything today.")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.65))
                }
                .padding(.top, 40)
                .padding(.bottom, 16)


                TimelineCardView(
                    startDate: today,
                    reminderDate: reminderDate,
                    activationDate: activationDate
                )

                HStack(spacing: 12) {

                    planButton(title: "Monthly", plan: .monthly)
                    planButton(title: "Annual", plan: .annual)

                }

                Toggle(isOn: $trialEnabled) {

                    VStack(alignment: .leading, spacing: 2) {

                        Text(trialEnabled
                             ? "Free trial enabled"
                             : "Not sure? Start with a free trial")
                            .foregroundColor(.white)

                        Text(trialEnabled
                             ? "You won’t be charged today"
                             : "You can cancel anytime")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }

                }
                .toggleStyle(SwitchToggleStyle(tint: .white.opacity(0.18)))
                .padding(.horizontal, 24)
                .padding(.top, 6)


                Spacer()

                VStack(spacing: 12) {

                    Button {

                        // DEV SIMULATION ONLY
                        print("Plan:", selectedPlan)
                        print("Trial:", trialEnabled)
                        
                    } label: {
                        Text(trialEnabled ? "Start Free Trial" : "Unlock Pro Now")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }

                }
                .padding(.horizontal, 24)

                Spacer(minLength: 24)
            }
            
            // CLOSE BUTTON (SCREEN LEVEL)
            VStack {
                HStack {
                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(16)
                            .opacity(0.8)

                    }
                }

                Spacer()
            }
            .padding(.top, 20)
            .padding(.trailing, 10)

        }
    }
    
    private func planButton(title: String, plan: PlanType) -> some View {

        let isSelected = selectedPlan == plan

        return Button {
            selectedPlan = plan
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Color.white : Color.white.opacity(0.08))
                .cornerRadius(12)
        }
    }

}
