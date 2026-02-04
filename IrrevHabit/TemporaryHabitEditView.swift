//
//  TemporaryHabitEditView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 04/02/26.
//
import SwiftUI

struct TemporaryHabitEditView: View {

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
                    saveChanges()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            title = habit.title
        }
    }

    private func saveChanges() {
        guard let index = store.standards.firstIndex(where: { $0.id == habit.id }) else {
            dismiss()
            return
        }

        var updated = store.standards[index]
        updated.title = title
        store.standards[index] = updated

        dismiss()
    }
}
