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
                for record in store.history {
                    print("record",
                          record.standardID,
                          record.status,
                          record.date)
                }
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(
                                        isToday(day) ? Color.white.opacity(0.5) : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )

                    }
                }
                .padding(.vertical, 4)
            }
            .frame(height: 7 * 14)
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

        for record in store.history {
            if record.standardID == standardID &&
               calendar.isDate(record.date, inSameDayAs: day) {

                print("MATCH FOUND →", standardID, day, record.status)
                return record.status
            }
        }

        return nil
    }
    
    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
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

    private var gridDays: [Date] {
        lastDays(daysToShow)
    }

    private func dayKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

}
