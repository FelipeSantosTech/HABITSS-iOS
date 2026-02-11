//
//  ProTabView.swift .swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 02/02/26.
//
import SwiftUI

struct ProTabView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                // HEADER
                ProHeaderView()
                    .padding(.bottom, 8)
                
                // Blocking (Hero)
                BlockingCardView()
                    .padding(.top, 4)
                
                // Flexible Standards
                FlexibleStandardsCardView()
                
                // Danger Zone
                DangerZoneCardView()
                    .padding(.top, 12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
    }
}

extension Color {
    static let cardBackground = Color.black
    static let cardBorder = Color.white.opacity(0.15)
    static let cardBorderDanger = Color.red.opacity(0.6)
}


