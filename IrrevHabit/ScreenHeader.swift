//
//  ScreenHeader.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 23/01/26.
//

import SwiftUI

struct ScreenHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String?

    init(
        eyebrow: String,
        title: String,
        subtitle: String? = nil
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eyebrow.uppercased())
                .font(.caption)
                .tracking(2)
                .foregroundColor(.gray)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}
