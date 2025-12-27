//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
//
import SwiftUI
struct ContentView: View {
  @EnvironmentObject var store: StandardsStore
  @AppStorage("acceptedReality") private var acceptedReality = false
    
    var body: some View {
        if !acceptedReality {
            OnboardingView()
        } else if !store.areStandardsLocked{
            SetupView()
        } else {
            MainView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StandardsStore())
}
