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
                VStack(alignment: .leading, spacing: 6) {

                    // Month labels
                    ZStack(alignment: .leading) {
                        ForEach(monthLabels) { label in
                            Text(label.text.uppercased())
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .offset(x: CGFloat(label.weekIndex) * 14)
                        }
                    }
                    .frame(height: 14)

                    // Grid
                    LazyHGrid(
                        rows: Array(
                            repeating: GridItem(.fixed(10), spacing: 4),
                            count: 7
                        ),
                        spacing: 4
                    ) {
                        ForEach(gridDays, id: \.self) { day in
                            let status = statusForDay(day, standardID: standard.id)

                            ZStack {
                                Rectangle()
                                    .fill(color(for: status))
                                    .opacity(opacity(for: day))

                                if Calendar.current.isDateInToday(day) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.white, lineWidth: 1)
                                }
                            }
                            .frame(width: 9, height: 9)

                        }
                    }
                }
                .padding(.vertical, 4)
            }

            .frame(height: 7 * 14)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )

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
    
    private func opacity(for day: Date) -> Double {
        let calendar = Calendar.current
        let daysAgo = calendar.dateComponents([.day], from: day, to: Date()).day ?? 0

        let maxFadeDays = 180.0   // full semester
        let normalized = min(Double(daysAgo) / maxFadeDays, 1.0)

        // 1.0 (today) → 0.25 (oldest)
        return 1.0 - (normalized * 0.75)
    }
    
    private struct MonthLabel: Identifiable {
        let id = UUID()
        let text: String
        let weekIndex: Int
    }

    private var monthLabels: [MonthLabel] {
        let calendar = Calendar.current
        var labels: [MonthLabel] = []
        var seenMonths: Set<Int> = []

        for (index, date) in gridDays.enumerated() {
            let month = calendar.component(.month, from: date)
            let weekIndex = index / 7

            if !seenMonths.contains(month) {
                seenMonths.insert(month)

                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                let text = formatter.string(from: date)

                labels.append(
                    MonthLabel(text: text, weekIndex: weekIndex)
                )
            }
        }

        return labels
    }


    private func dayKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

}
