//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
//
import SwiftUI
struct ContentView: View {
    @EnvironmentObject var proManager: ProManager
    @State private var showDevPanel = false
  @EnvironmentObject var store: StandardsStore
  @AppStorage("acceptedReality") private var acceptedReality = false
    @State private var selectedTab = 0

    var body: some View {

        ZStack {

            Group {

                if !acceptedReality {
                    OnboardingContainerView()

                } else if !store.areStandardsLocked {
                    SetupView()

                } else {

                    ZStack {
                        Color.black.ignoresSafeArea()

                        TabView(selection: $selectedTab) {
                            MainView().tag(0)
                            HistoryView().tag(1)
                            ProTabView().tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .safeAreaInset(edge: .bottom) {
                        BottomNavBar(selectedTab: $selectedTab)
                    }
                }
            }

        }
        // 👇 DEV LONG PRESS
        .contentShape(Rectangle())
        .onLongPressGesture(minimumDuration: 2) {
            showDevPanel = true
        }
        .sheet(isPresented: $showDevPanel) {
            DevPanelView()
                .environmentObject(proManager)
        }
    }

}

#Preview {
    ContentView()
        .environmentObject(StandardsStore())
}
