//
//  PaywallTimelineView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 06/02/26.
//

import SwiftUI

struct PaywallTimelineView: View {
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

            VStack(spacing: 32) {


                Spacer()
                VStack(spacing: 10) {

                    Text("How your free trial works")
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

                Spacer()

                VStack(spacing: 12) {

                    Button {
                        // Start trial / purchase logic later
                    } label: {
                        Text("Start Free Trial")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }

                    Button {
                        // Direct purchase logic later
                    } label: {
                        Text("Unlock Pro Now")
                            .foregroundColor(.gray)
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
}
