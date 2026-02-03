//
//  SetupView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 25/12/25.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var proManager: ProManager
    @State private var showPaywall = false
    @State private var showSuperHabitWarning = false
    @State private var selectedStandard: Standard?
    
    @EnvironmentObject var store: StandardsStore
    @State private var newStandardTitle: String = ""
    @State private var showLockConfirmation: Bool = false
    @State private var confirmationText: String = ""
    @State private var editingStandardID: UUID? = nil
    @State private var editedTitle: String = ""
    @State private var lockConfirmation = ""


    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            ScrollView {
            
            VStack (spacing: 32){
                
                ScreenHeader(
                    eyebrow: "Setup",
                    title: "Define your standards",
                    subtitle: "These are non-negotiable behaviors you commit to execute daily."
                )

                .padding(.bottom, 24)

                VStack(spacing: 12) {
                    TextField("", text: $newStandardTitle)
                        .placeholder(when: newStandardTitle.isEmpty) {
                            Text("e.g. Sleep before 23:00")
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding()
                        .background(Color(white: 0.15))
                        .cornerRadius(6)
                        .foregroundColor(.white)

                    
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
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(1)
                    .padding(.vertical, 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    
                    if store.standards.count >= store.maxStandards {
                        Text("Maximum of 5 standards allowed.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(store.standards) { standard in
                        ZStack(alignment: .topTrailing) {
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
                            
                            standards(for: standard)

                            starButton(for: standard)
                                .padding(8)
                    }
                }
                    
                }
                
                .padding(.bottom, 40)
                //Lock section
                VStack(spacing: 12) {
                    Text("Once locked, standards cannot be changed.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 12) {

                        TextField("", text: $lockConfirmation)
                            .placeholder(when: lockConfirmation.isEmpty) {
                                Text("TYPE LOCK TO CONFIRM")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .textInputAutocapitalization(.characters)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color(white: 0.15))
                            .cornerRadius(6)
                            .foregroundColor(.white)

                        Button("CONFIRM & LOCK") {
                            store.lockStandards()
                        }
                        .disabled(lockConfirmation != "LOCK")
                        .foregroundColor(.black)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(lockConfirmation == "LOCK" ? Color.white : Color.gray)
                    }
                    .padding(.top, 16)

                    .background(Color(white: 0.05))
                    .cornerRadius(8)
                }
                
                
            }
            .sheet(isPresented: $showPaywall) {
                VStack(spacing: 20) {
                    Text("HABITSS Pro")
                        .font(.title)

                    Text("Unlock habit flexibility and advanced control.")

                    Button("Close") {
                        showPaywall = false
                    }
                    
                }
                
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
            }
            .confirmationDialog(
                "Change Habit Type?",
                isPresented: $showSuperHabitWarning,
                titleVisibility: .visible
            ) {

                Button("Make Temporary Habit") {
                    // Next step we’ll mutate type here
                }

                Button("Cancel", role: .cancel) {}
            } message: {

                Text("Temporary habits can be edited and replaced, but their history resets.")
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

    private func handleStarTap(_ standard: Standard) {

        selectedStandard = standard

        if !proManager.isProUser {
            showPaywall = true
        } else {
            showSuperHabitWarning = true
        }
    }
    
    private func starButton(for standard: Standard) -> some View {
        Button {
            handleStarTap(standard)
        } label: {
            Image(systemName: standard.isSuper ? "star.fill" : "star")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(standard.isSuper ? .yellow : .gray.opacity(0.6))
                .padding(6)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.4))
                )
        }
        .buttonStyle(.plain)
    }

}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
