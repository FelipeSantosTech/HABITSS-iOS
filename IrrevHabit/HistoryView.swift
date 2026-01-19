//
//  HistoryView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 03/01/26.
//


import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: StandardsStore

    private let daysToShow = 182

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    // HEADER
                    VStack(alignment: .leading, spacing: 8) {
                        Text("HISTORY")
                            .font(.caption)
                            .tracking(2)
                            .foregroundColor(.gray)

                        Text("Consistency over time")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }

                    // PANELS
                    ForEach(store.standards) { standard in
                        standardHistoryPanel(for: standard)
                    }
                }
                .padding()
            }
            .onAppear {
                print("History count:", store.history.count)
            }
        }
    }
    private func standardHistoryPanel(for standard: Standard) -> some View {
        return VStack(alignment: .leading, spacing: 12) {
            Text(standard.title)
                .foregroundColor(.white)
                .fontWeight(.medium)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(
                    rows: Array(
                        repeating: GridItem(.fixed(10), spacing: 4),
                        count: 7
                    ),
                    spacing: 4
                ) {
                    ForEach(gridDays, id: \.self) { day in
                        let status = statusForDay(day, standardID: standard.id)

                        Rectangle()
                            .fill(color(for: status))
                            .frame(width: 10, height: 10)
                            .cornerRadius(2)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private func lastDays(_ count: Int) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<count)
            .compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            .reversed()
    }

    private func statusForDay(_ day: Date, standardID: UUID) -> DailyStatus? {
        let calendar = Calendar.current

        return store.history.first {
            $0.standardID == standardID &&
            calendar.isDate($0.date, inSameDayAs: day)
        }?.status
    }


    private func color(for status: DailyStatus?) -> Color {
        switch status {
        case .done:
            return .green
        case .missed:
            return .red
        default:
            return Color(white: 0.15)
        }
    }
    
    private var numberOfWeeks: Int {
        Int(ceil(Double(daysToShow) / 7.0))
    }

    private var gridDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let startDate = calendar.date(
            byAdding: .day,
            value: -(daysToShow - 1),
            to: today
        )!

        // Align start date to beginning of week (Sunday)
        let weekday = calendar.component(.weekday, from: startDate)
        let alignedStart = calendar.date(
            byAdding: .day,
            value: -(weekday - 1),
            to: startDate
        )!

        let totalDays = numberOfWeeks * 7

        return (0..<totalDays).compactMap {
            calendar.date(byAdding: .day, value: $0, to: alignedStart)
        }
    }

}
