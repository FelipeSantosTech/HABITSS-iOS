//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
//
import SwiftUI
struct ContentView: View {
  @AppStorage("acceptedReality") private var acceptedReality = false
    @EnvironmentObject var store: StandardsStore
    
    var body: some View {
        if !acceptedReality {
            OnboardingView()
        } else if !store.isLocked{
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
