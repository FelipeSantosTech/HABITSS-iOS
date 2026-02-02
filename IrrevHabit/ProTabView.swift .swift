//
//  ProTabView.swift .swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 02/02/26.
//

import SwiftUI

struct ProTabView: View {

    @EnvironmentObject var proManager: ProManager

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {

                Spacer()

                Text("HABITSS PRO")
                    .font(.title2)
                    .foregroundColor(.white)

                if proManager.isProUser {

                    Text("Pro unlocked")
                        .foregroundColor(.green)
                    
                    Button("DEV: Remove Pro") {
                        proManager.disableProForDebug()
                    }

                } else {

                    Text("Upgrade to unlock system-level tools")
                        .foregroundColor(.gray)
                    
                    Button("DEV: Become Pro") {
                        proManager.enableProForDebug()
                    }

                    NavigationLink {
                        PaywallView()
                    } label: {
                        Text("View Pro")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()
            }
        }
    }
}
