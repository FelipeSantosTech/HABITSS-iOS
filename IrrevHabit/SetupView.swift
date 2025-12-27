//
//  SetupView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 25/12/25.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var store: StandardsStore
    @State private var newStandardTitle: String = ""
    
    var body: some View {
        VStack (spacing: 24){
            Text("Define your Daily Standards")
                .font(.title2)
                .fontWeight(.bold)
           
            VStack(spacing: 12) {
                TextField("Enter a standard", text: $newStandardTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add Standard"){
                    addStandard()
                }
                .disabled(newStandardTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            List(store.standards) { standard in
                Text(standard.title)
            }
            
            Divider()
            
            VStack(spacing: 12) {
                Text("Once locked, standards cannot be changed.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Button("LOCK STANDARDS") {
                    store.lockStandards()
                }
                .disabled(!store.canLockStandards)
                .buttonStyle(.borderedProminent)
            }
            
        }
        .padding()
    }
    
    private func addStandard () {
        let trimed = newStandardTitle.trimmingCharacters(in: .whitespaces)
        guard !trimed.isEmpty else { return }
        
        let standard = Standard (
            id: UUID(),
            title: trimed,
            status: .pending
        )
        
        store.standards.append(standard)
        newStandardTitle = ""
    }
}

#Preview {
    SetupView()
        .environmentObject(StandardsStore())
}
