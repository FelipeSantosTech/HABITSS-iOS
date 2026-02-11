//
//  MainView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import SwiftUI
struct MainView: View {
    @EnvironmentObject var store: StandardsStore
    @State private var editingTemporaryHabit: Standard?
    @State private var showTemporaryEditSheet = false

    var body: some View {

        ZStack(alignment: .bottom) {

            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    ScreenHeader(
                        eyebrow: "Execute",
                        title: "Today's habits"
                    )

                    if store.isDayComplete {
                        Text("Day complete. Come back tomorrow.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }

                    VStack(spacing: 16) {
                        ForEach(store.standards.indices, id: \.self) { index in
                            standardCard(for: index)
                        }
                    }

                    Spacer(minLength: 24)
                }
                .padding()
            }

            // 👇 Bottom fade (IDENTICAL behavior to HistoryView)
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 14)
            .allowsHitTesting(false)
        }
        .sheet(isPresented: $showTemporaryEditSheet) {
            if let habit = editingTemporaryHabit {
                TemporaryHabitEditView(habit: habit)
                    .environmentObject(store)
            }
        }
        .onAppear {
            store.resetForNewDayIfNeeded()
        }
    }

    
    @ViewBuilder
    private func standardCard(for index: Int) -> some View {
        let standard = store.standards[index]
        
        VStack(spacing: 13) {
            
        HStack {
            Text(standard.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()

                   habitTypeIcon(for: standard)
               }
            
            if store.isDayComplete {
                Text(standard.status == .done ? "COMPLETED" : "MISSED")
                    .font(.caption)
                    .tracking(1)
                    .foregroundColor(standard.status == .done ? .green : .red)
            } else if standard.status == .pending {
                HStack(spacing: 12) {
                    Button("DONE") {
                        store.markDone(at: index)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)

                    Button("MISSED") {
                        store.markMissed(at: index)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(white: 0.2))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
            } else {
                Text(standard.status == .done ? "COMPLETED" : "MISSED")
                    .font(.caption)
                    .tracking(1)
                    .foregroundColor(standard.status == .done ? .green : .red)
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(white: 0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )

    }
    
    @ViewBuilder
    private func habitTypeIcon(for standard: Standard) -> some View {

        if standard.isSuper {

            Image(systemName: "lock.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))

        } else {

            Button {
                handleTemporaryEditTap(standard)
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .buttonStyle(.plain)

        }
    }

    
    private func handleTemporaryEditTap(_ standard: Standard) {
        editingTemporaryHabit = standard
        showTemporaryEditSheet = true
    }


}

#Preview {
    MainView()
        .environmentObject(StandardsStore())
}
