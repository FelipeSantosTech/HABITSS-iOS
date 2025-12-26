//
//  MainView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import SwiftUI
struct MainView: View {
    @EnvironmentObject var store: StandardsStore
    
    var body: some View {
        
        Text("Welcome to IRREV")
            .font(.title)
    }
}

#Preview {
    MainView()
        .environmentObject(StandardsStore())
}
