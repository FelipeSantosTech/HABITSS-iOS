//
//  TimelineCardView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 06/02/26.
//

import SwiftUI

struct TimelineCardView: View {

    let startDate: Date
    let reminderDate: Date
    let activationDate: Date

    var body: some View {

        HStack(alignment: .top, spacing: 15) {

            Image("timeline_rail")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 46)
                .frame(maxHeight: .infinity)
                .clipped()
                .fixedSize(horizontal: true, vertical: false)
            
                // EVENTS
                VStack(alignment: .leading, spacing: 30) {
                    
                    TimelineRowView(
                        title: "Install the app",
                        subtitle: "Track your habits",
                        isPrimary: true
                    )

                    TimelineRowView(
                        title: "Today — Trial starts",
                        subtitle: "Pro features are unlocked. No charge today."
                    )

                    TimelineRowView(
                        title: "\(reminderDate.paywallFormatted()) — Reminder",
                        subtitle: "We’ll remind you your trial is ending soon."
                    )

                    TimelineRowView(
                        title: "\(activationDate.paywallFormatted()) — Membership begins",
                        subtitle: "Membership begins unless cancelled before this date."
                    )
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(26)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.22), lineWidth: 1.2)
        )
        .cornerRadius(20)

    }
}
