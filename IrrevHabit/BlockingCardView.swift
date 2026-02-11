//
//  BlockingCardView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 11/02/26.
//


import SwiftUI

struct BlockingCardView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Distraction Blocking")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
            
            Text("Lock distractions until your standards are finished.")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.7))
            
            Divider()
                .overlay(Color.white.opacity(0.15))
                .padding(.vertical, 4)
            
            HStack {
                Text("Status")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
                
                Text("Not Configured")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

