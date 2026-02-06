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
                            
                            starButton(for: standard)
                                .padding(8)
                    }
                }
                    
                }
                
                .padding(.bottom, 40)
                //Lock section
                
                
            }
            .sheet(isPresented: $showPaywall) {
                PaywallTimelineView()
            }


        }
            .padding()
            
            if showSuperHabitWarning {

                // Dim background
                Color.black.opacity(0.7)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 20) {

                        Text("Convert to Temporary Habit?")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text("Temporary habits can be edited. Editing will reset their history.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        VStack(spacing: 12) {

                            Button {
                                showSuperHabitWarning = false
                                convertSelectedHabitToTemporary()
                            } label: {
                                Text("Convert")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }

                            Button {
                                showSuperHabitWarning = false
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 6)
                            }
                        }
                    }
                    .padding(24)
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.15))
                    )
                    .cornerRadius(18)
                    .padding(32)

                    Spacer()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            lockBar
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

    private var lockBar: some View {
        VStack(spacing: 6) {

            Text("Once locked, standards cannot be changed.")
                .font(.footnote)
                .foregroundColor(.gray)

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
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)      // 👈 KEY
        .padding(.bottom, 6)
        .background(
            ZStack(alignment: .top) {

                // Solid bar background
                Color.black

                // Stronger + taller fade ABOVE bar
                LinearGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.4),
                        Color.black.opacity(0.85),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80) // <-- KEY CHANGE (was 40ish)
                .offset(y: -80)    // <-- Pulls fade into content area
            }
        )

    }

    private func handleStarTap(_ standard: Standard) {

        selectedStandard = standard

        // If user tries to REMOVE super status → Pro gate
        if standard.isSuper {

            if !proManager.isProUser {
                showPaywall = true
            } else {
                showSuperHabitWarning = true
            }

        } else {

            // Temporary → Super (allowed always)
            convertSelectedHabitToSuper()

        }
    }

    
    private func starButton(for standard: Standard) -> some View {
        Button {
            handleStarTap(standard)
        } label: {
            Image(systemName: standard.isSuper ? "star.fill" : "star")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(
                    standard.isSuper
                    ? Color.white.opacity(0.9)
                    : Color.white.opacity(0.25)
                )
                .padding(6)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.05))
                )
        }
        .buttonStyle(.plain)
    }
    
    private func convertSelectedHabitToTemporary() {
        guard let selected = selectedStandard else { return }

        if let index = store.standards.firstIndex(where: { $0.id == selected.id }) {
            var updated = store.standards[index]
            updated.type = .temporary
            store.standards[index] = updated
        }
    }

    private func convertSelectedHabitToSuper() {
        guard let selected = selectedStandard else { return }

        if let index = store.standards.firstIndex(where: { $0.id == selected.id }) {
            var updated = store.standards[index]
            updated.type = .superHabit
            store.standards[index] = updated
        }
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
