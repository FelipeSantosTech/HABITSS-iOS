//
//  HistoryView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 03/01/26.
//


import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: StandardsStore

    private let daysToShow = 90

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
        }
    }
    private func standardHistoryPanel(for standard: Standard) -> some View {
        let days = lastDays(daysToShow)
        let records = historyForStandard(standard.id)

        return VStack(alignment: .leading, spacing: 12) {
            Text(standard.title)
                .foregroundColor(.white)
                .fontWeight(.medium)

            LazyVGrid(
                columns: Array(repeating: GridItem(.fixed(10), spacing: 4), count: 10),
                spacing: 4
            ) {
                ForEach(days, id: \.self) { day in
                    let status = records[day]

                    Rectangle()
                        .fill(color(for: status))
                        .frame(width: 12, height: 12)
                        .cornerRadius(2)
                }
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

    private func historyForStandard(_ id: UUID) -> [Date: DailyStatus] {
        var map: [Date: DailyStatus] = [:]
        let calendar = Calendar.current

        for record in store.history where record.standardID == id {
            let day = calendar.startOfDay(for: record.date)
            map[day] = record.status
        }

        return map
    }

    private func color(for status: DailyStatus?) -> Color {
        switch status {
        case .done:
            return .white
        case .missed:
            return Color(white: 0.2)
        default:
            return Color(white: 0.08)
        }
    }

}
