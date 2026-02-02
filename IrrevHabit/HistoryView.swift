//
//  HistoryView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 03/01/26.
//


import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: StandardsStore

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    // HEADER
                    ScreenHeader(
                        eyebrow: "History",
                        title: "Consistency over time"
                    )


                    // PANELS
                    ForEach(store.standards) { standard in
                        standardHistoryPanel(for: standard)
                    }
                }
                .padding(.bottom, 56)
            }
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
    }
    
    
    
    
    
    private func standardHistoryPanel(for standard: Standard) -> some View {
        return VStack(alignment: .leading, spacing: 12) {
            Text(standard.title)
                .foregroundColor(.white)
                .fontWeight(.medium)

                VStack(alignment: .leading, spacing: 6) {
                    let grid = CalendarGridEngine.generateGrid()

                    
                    let labels = monthLabels(from: grid)

                    // Month labels
                    ZStack(alignment: .leading) {
                        ForEach(labels) { label in
                            Text(label.text.uppercased())
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .offset(x: CGFloat(label.weekIndex) * 13)
                        }
                    }

                    .frame(height: 14)

                    // Grid

                    VStack(spacing: 4) {
                        ForEach(0..<7, id: \.self) { row in
                            HStack(spacing: 4) {
                                ForEach(0..<grid.count, id: \.self) { column in
                                    let cell = grid[column][row]

                                    let status = statusForDay(cell.date, standardID: standard.id)

                                    let baseOpacity = cell.isFuture ? 0.0 : 0.15 * opacity(for: cell.date)

                                    let fillColor: Color = {
                                        if cell.isFuture { return .clear }

                                        switch status {
                                        case .done:
                                            return Color(red: 0.25, green: 0.65, blue: 0.45) // premium muted green

                                        case .missed:
                                            return Color(red: 0.65, green: 0.28, blue: 0.30) // muted deep red

                                        default:
                                            return Color.white.opacity(baseOpacity) // timeline fade
                                        }
                                    }()

                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(fillColor)
                                        .overlay {
                                            if cell.isToday {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .stroke(Color.white.opacity(0.75), lineWidth: 1.2)
                                            }
                                        }
                                        .frame(width: 9, height: 9)


                                }
                            }
                        }
                    }

                }
            .padding(.vertical, 4)
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

    private func monthLabels(from grid: [[CalendarGridEngine.DayCell]]) -> [MonthLabel] {
        let calendar = Calendar.current
        var labels: [MonthLabel] = []
        var lastMonth: Int?

        for (columnIndex, column) in grid.enumerated() {
            guard let firstDay = column.first else { continue }

            let month = calendar.component(.month, from: firstDay.date)

            if month != lastMonth {
                lastMonth = month

                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"

                labels.append(
                    MonthLabel(
                        text: formatter.string(from: firstDay.date),
                        weekIndex: columnIndex
                    )
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
