//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
//
import SwiftUI
struct ContentView: View {
  @AppStorage("acceptedReality") private var acceptedReality = false
    
    var body: some View {
        if acceptedReality {
            MainView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
