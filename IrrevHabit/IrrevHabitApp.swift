//
//  IrrevHabitApp.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 23/12/25.
//

import SwiftUI

@main
struct IrrevHabitApp: App {
    
    @StateObject private var store = StandardsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
