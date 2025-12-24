//  OnboardingView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("acceptedReality") private var acceptedReality=false
    @State private var rejectedReality = false
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Spacer()
                VStack(spacing:24){
                    VStack(spacing:12){
                        Text("IRREV does not motivate you")
                        Text("It records what you actually do")
                        Text("Misses are permanent")
                    }
                    Text("ARE YOU READY TO SEE THE TRUTH AND CHANGE YOUR REALITY?")
                        .font(.headline)
                    VStack(spacing: 12){
                        Button("YES"){
                            acceptedReality = true
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        
                        Button("NO"){
                            rejectedReality = true
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    if rejectedReality{
                        Text("Then this app is not for you.")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.top, 8)
                    }
                }
                .foregroundColor(.white)
                .font(.system(.body, design: .monospaced))
                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    OnboardingView()
}
