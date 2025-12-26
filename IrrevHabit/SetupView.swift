//
//  SetupView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 25/12/25.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var store: StandardsStore
    
    var body: some View {
        VStack{
            Text("Setup Standards")
            
            Button("Lock Standards"){
                store.lockStandards()
            }
        }
    }
}

#Preview {
    SetupView()
        .environmentObject(StandardsStore())
}
