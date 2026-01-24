//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
//
import SwiftUI
struct ContentView: View {
  @EnvironmentObject var store: StandardsStore
  @AppStorage("acceptedReality") private var acceptedReality = false
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if !acceptedReality {
                OnboardingContainerView()
            } else if !store.areStandardsLocked{
                SetupView()
            } else {
                ZStack {
                    Color.black.ignoresSafeArea()

                    TabView(selection: $selectedTab) {
                        MainView()
                            .tag(0)

                        HistoryView()
                            .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .safeAreaInset(edge: .bottom) {
                    BottomNavBar(selectedTab: $selectedTab)
                }



            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StandardsStore())
}
