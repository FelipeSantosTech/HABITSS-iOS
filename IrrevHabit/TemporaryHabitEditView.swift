//
//  TemporaryHabitEditView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 04/02/26.
//
import SwiftUI

struct TemporaryHabitEditView: View {
    @State private var showMakeSuperWarning = false
    @State private var showResetWarning = false
    @EnvironmentObject var store: StandardsStore
    @Environment(\.dismiss) private var dismiss

    let habit: Standard

    @State private var title: String = ""

    var body: some View {

        ZStack {

            // ===== BACKGROUND =====
            Color.black.ignoresSafeArea()

            // ===== MAIN CONTENT =====
            VStack(spacing: 16) {

                Text("Edit Habit")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                ZStack(alignment: .leading) {

                    if title.isEmpty {
                        Text("New Habit Name")
                            .foregroundColor(.white.opacity(0.35))
                            .padding(.horizontal, 16)
                    }

                    TextField("", text: $title)
                        .foregroundColor(.white)
                        .padding()
                        .tint(.white)
                }
                .background(Color.white.opacity(0.08))
                .cornerRadius(10)


                VStack(alignment: .leading, spacing: 4) {

                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.vertical, 8)

                    Text("Temporary habits")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("• Can be edited\n• Editing resets history")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.9))
                }

                Spacer()
            }
            .padding()

            // ===== FIXED BOTTOM ACTION BAR =====
            VStack {
                Spacer()

                bottomActionBar
            }

            // ===== OVERLAY LAYER =====
            if showResetWarning || showMakeSuperWarning {

                overlayDimLayer

                confirmationCardLayer
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showResetWarning)
        .animation(.easeInOut(duration: 0.2), value: showMakeSuperWarning)

    }

    private var bottomActionBar: some View {

        VStack(spacing: 12) {

            Button {
                showResetWarning = true
            } label: {
                Text("Save Changes")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }

            Button {
                showMakeSuperWarning = true
            } label: {
                VStack(spacing: 4) {
                    Text("Make Super Habit")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Lock this habit permanently")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2))
                )
                .cornerRadius(10)
            }

            Button {
                dismiss()
            } label: {
                Text("Close")
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.black.opacity(0.95))
    }

    private var overlayDimLayer: some View {

        Color.black.opacity(0.7)
            .ignoresSafeArea()
            .transition(.opacity)
    }

    private var confirmationCardLayer: some View {

        VStack {

            Spacer()

            VStack(spacing: 20) {

                Text(cardTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(cardMessage)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {

                    Button {
                        confirmPrimaryAction()
                    } label: {
                        Text(cardPrimaryText)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button {
                        cancelCard()
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
        .transition(.opacity)
    }

    private var cardTitle: String {
        showResetWarning
        ? "Reset History?"
        : "Convert to Super Habit?"
    }

    private var cardMessage: String {
        showResetWarning
        ? "Editing temporary habits resets their history."
        : "Super habits cannot be edited individually. They can only be removed via a full system reset."
    }

    private var cardPrimaryText: String {
        showResetWarning
        ? "Save & Reset"
        : "Convert & Lock"
    }

    private func confirmPrimaryAction() {

        if showResetWarning {
            showResetWarning = false
            saveChangesAndResetHistory()
        }

        if showMakeSuperWarning {
            showMakeSuperWarning = false
            convertToSuperHabit()
        }
    }

    private func cancelCard() {
        showResetWarning = false
        showMakeSuperWarning = false
    }


    private func saveChangesAndResetHistory() {

        guard let index = store.standards.firstIndex(where: { $0.id == habit.id }) else {
            dismiss()
            return
        }

        var updated = store.standards[index]

        // Update title
        updated.title = title

        // ✅ CRITICAL — Reset TODAY status
        updated.status = .pending

        store.standards[index] = updated

        // ✅ Remove ALL history for this habit
        store.history.removeAll { $0.standardID == habit.id }

        dismiss()
    }

    private func convertToSuperHabit() {

        guard let index = store.standards.firstIndex(where: { $0.id == habit.id }) else {
            dismiss()
            return
        }

        var updated = store.standards[index]

        // Convert type
        updated.type = .superHabit

        store.standards[index] = updated

        dismiss()
    }


}
