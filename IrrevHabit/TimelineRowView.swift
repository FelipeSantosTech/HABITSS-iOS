//
//  TimelineRowView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 06/02/26.
//

import SwiftUI

struct TimelineRowView: View {

    let title: String
    let subtitle: String
    var isPrimary: Bool = false

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(isPrimary ? .system(size: 20, weight: .semibold)
                                : .system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(isPrimary ? 0.97 : 0.92))
                .fixedSize(horizontal: false, vertical: true)

            Text(subtitle)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)

        }
    }
}


