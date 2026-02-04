//
//  DevPanelView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 04/02/26.
//

import SwiftUI

struct DevPanelView: View {

    @EnvironmentObject var proManager: ProManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {

                Text("DEV PANEL")
                    .font(.headline)
                    .foregroundColor(.white)

                Button(proManager.isProUser ? "Disable Pro" : "Enable Pro") {
                    proManager.isProUser.toggle()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)

                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
    }
}
