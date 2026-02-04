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
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {

                Text("Edit Temporary Habit")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Habit title", text: $title)
                    .padding()
                    .background(Color(white: 0.15))
                    .foregroundColor(.white)
                    .cornerRadius(6)

                Button("Save Changes") {
                    showResetWarning = true
                }
                .confirmationDialog(
                    "Editing will reset this habit's history",
                    isPresented: $showResetWarning,
                    titleVisibility: .visible
                ) {

                    Button("Save & Reset History", role: .destructive) {
                        saveChangesAndResetHistory()
                    }

                    Button("Cancel", role: .cancel) { }

                } message: {
                    Text("Temporary habits lose historical continuity when edited.")
                }

                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)

                Spacer()
                
                Button {
                    showMakeSuperWarning = true
                } label: {
                    Text("Make Super Habit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .confirmationDialog(
                    "Convert to Super Habit?",
                    isPresented: $showMakeSuperWarning,
                    titleVisibility: .visible
                ) {

                    Button("Convert & Lock", role: .destructive) {
                        convertToSuperHabit()
                    }

                    Button("Cancel", role: .cancel) { }

                } message: {
                    Text("Super Habits cannot be edited individually. You can only remove them via full system reset.")
                }

                .padding(.top, 8)

            }
            .padding()
        }
        .onAppear {
            title = habit.title
        }
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
