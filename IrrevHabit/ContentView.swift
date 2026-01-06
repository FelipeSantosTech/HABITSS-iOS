//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
//
import SwiftUI
struct ContentView: View {
  @EnvironmentObject var store: StandardsStore
  @AppStorage("acceptedReality") private var acceptedReality = false
    
    var body: some View {
        Group {
            if !acceptedReality {
                OnboardingView()
            } else if !store.areStandardsLocked{
                SetupView()
            } else {
                TabView {
                    MainView()
                        .tabItem {
                            Label("Execute", systemImage: "checkmark.circle")
                        }

                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "square.grid.3x3")
                        }
                }

            }
        }
        .onAppear {
            // #region agent log
            AgentDebugLog.log(
                runId: "baseline",
                hypothesisId: "H1",
                location: "ContentView.swift:onAppear",
                message: "ContentView decided root flow",
                data: [
                    "acceptedReality": acceptedReality,
                    "areStandardsLocked": store.areStandardsLocked,
                    "standardsCount": store.standards.count,
                    "historyComputedCount": store.history.count
                ]
            )
            // #endregion
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StandardsStore())
}
