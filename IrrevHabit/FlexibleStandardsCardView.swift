//
//  FlexibleStandardsCardView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 11/02/26.
//


import SwiftUI

struct FlexibleStandardsCardView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Flexible Standards")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
            
            Text("Decide what is permanent and what is temporary.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

