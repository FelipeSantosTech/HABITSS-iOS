//
//  PaywallView .swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 02/02/26.
//

import SwiftUI

struct PaywallView: View {

    @EnvironmentObject var proManager: ProManager

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {

                Spacer()

                Text("HABITSS PRO")
                    .font(.title)
                    .foregroundColor(.white)

                Text("System-level discipline tools.")
                    .foregroundColor(.gray)

                Button("Unlock Pro (Dev)") {
                    proManager.enableProForDebug()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(12)

                Spacer()
            }
            .padding()
        }
    }
}
