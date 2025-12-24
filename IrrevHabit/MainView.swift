//
//  MainView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import SwiftUI
struct MainView: View {
    
    var body: some View {
        @EnvironmentObject var store: StandardsStore
        
        Text("Welcome to IRREV")
            .font(.title)
    }
}

#Preview {
    MainView()
}
