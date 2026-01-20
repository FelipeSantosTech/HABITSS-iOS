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
    @State private var showLockConfirmation: Bool = false
    @State private var confirmationText: String = ""
    @State private var editingStandardID: UUID? = nil
    @State private var editedTitle: String = ""

    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            ScrollView {
            
            VStack (spacing: 32){
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("DEFINE YOUR STANDARDS")
                        .font(.caption)
                        .tracking(2)
                        .foregroundColor(.gray)

                    Text("These are non-negotiable behaviors you commit to execute daily.")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Choose carefully. You cannot edit after locking.")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                .padding(.bottom, 24)

                VStack(spacing: 12) {
                    TextField("e.g. Sleep before 23:00", text: $newStandardTitle)
                        .padding()
                        .background(Color(white: 0.1))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    
                    Button("ADD STANDARD") {
                        let trimmed = newStandardTitle.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        
                        store.addStandard(title: trimmed)
                        newStandardTitle = ""
                    }
                    .disabled(
                        newStandardTitle.trimmingCharacters(in: .whitespaces).isEmpty
                        || !store.canAddStandard
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(white: 0.2))
                    .cornerRadius(6)
                    
                    if store.standards.count >= store.maxStandards {
                        Text("Maximum of 5 standards allowed.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    ForEach(store.standards) { standard in
                        VStack {
                            if editingStandardID == standard.id {
                                TextField("Edit standard", text: $editedTitle)
                                    .padding()
                                    .background(Color(white: 0.1))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                    .onSubmit {
                                        saveEdit(for: standard)
                                    }
                            } else {
                                Text(standard.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(white: 0.08))
                                    .cornerRadius(6)
                                    .onTapGesture {
                                        beginEditing(standard)
                                    }
                            }
                        }
                    }
                    
                }
                
                .padding(.bottom, 40)
                //Lock section
                VStack(spacing: 12) {
                    Text("Once locked, standards cannot be changed.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Button("LOCK STANDARDS") {
                        showLockConfirmation = true
                    }
                    .disabled(!store.canLockStandards)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(store.canLockStandards ? Color.white : Color(white: 0.3))
                    .foregroundColor(.black)
                    .cornerRadius(6)
                }
                
                if showLockConfirmation {
                    VStack(spacing: 16) {
                        Text("This action is irreversible.")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Type LOCK to confirm.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        TextField("LOCK", text: $confirmationText)
                            .padding()
                            .background(Color(white: 0.1))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .autocapitalization(.allCharacters)
                        
                        Button("CONFIRM & LOCK") {
                            store.lockStandards()
                        }
                        .disabled(confirmationText != "LOCK")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(confirmationText == "LOCK" ? Color.white : Color(white: 0.3))
                        .foregroundColor(.black)
                        .cornerRadius(6)
                    }
                    .padding()
                    .background(Color(white: 0.05))
                    .cornerRadius(8)
                }
                
                
            }
        }
            .padding()
        }
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
    
    private func beginEditing(_ standard: Standard) {
        guard !store.areStandardsLocked else { return }
        editingStandardID = standard.id
        editedTitle = standard.title
    }

    private func saveEdit(for standard: Standard) {
        guard let index = store.standards.firstIndex(where: { $0.id == standard.id }) else {
            editingStandardID = nil
            return
        }

        let trimmed = editedTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        store.standards[index].title = trimmed
        editingStandardID = nil
    }

}

#Preview {
    SetupView()
        .environmentObject(StandardsStore())
}
