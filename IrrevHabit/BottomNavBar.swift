//
//  BottomNavBar.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 23/01/26.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 48) {
            navButton(
                icon: "checklist",
                index: 0
            )

            navButton(
                icon: "square.grid.3x3.bottomright.filled",
                index: 1
            )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 32)
        .background(
            Color.black.opacity(0.9)
        )
    }

    private func navButton(icon: String, index: Int) -> some View {
        let isActive = selectedTab == index

        return Button {
            withAnimation(.easeOut(duration: 0.15)) {
                selectedTab = index
            }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .opacity(isActive ? 1.0 : 0.35)
        }
        .buttonStyle(.plain)
    }
}
