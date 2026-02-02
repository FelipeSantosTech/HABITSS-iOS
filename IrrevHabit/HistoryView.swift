//
//  HistoryView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 03/01/26.
//


import SwiftUI

struct HistoryView: View {
    
    private let weekdayColumnWidth: CGFloat = 26
    private let columnStride: CGFloat = 13 // square + spacing
    
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
                    let gridWidth = CGFloat(grid.count) * columnStride

                    HStack(spacing: 4) {

                        // Weekday placeholder (matches grid layout exactly)
                        Text("MON")
                            .font(.system(size: 9, weight: .medium, design: .monospaced))
                            .tracking(0.5)
                            .opacity(0)
                            .frame(width: weekdayColumnWidth, alignment: .leading)

                        // Month labels aligned to grid width
                        ZStack(alignment: .leading) {
                            ForEach(labels) { label in
                                Text(label.text.uppercased())
                                    .font(.caption2)
                                    .foregroundColor(.gray.opacity(0.9))
                                    .offset(x: CGFloat(label.weekIndex) * columnStride)
                            }
                        }
                        .frame(width: gridWidth, alignment: .leading)   // ⭐ THIS FIXES EVERYTHING
                    }
                    .frame(height: 14)
                    .clipped()


                    // Grid

                    VStack(spacing: 2) {
                        ForEach(0..<7, id: \.self) { row in

                            HStack(spacing: 4) {

                                // Weekday label column
                                Text(weekdayLabel(for: row)?.uppercased() ?? "MON")
                                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                                    .tracking(0.5)
                                    .foregroundColor(.gray.opacity(0.75))
                                    .opacity(weekdayLabel(for: row) == nil ? 0 : 1)
                                    .frame(width: 26, alignment: .leading)


                                // Grid squares
                                HStack(spacing: 4) {
                                    ForEach(0..<grid.count, id: \.self) { column in

                                        let cell = grid[column][row]
                                        let status = statusForDay(cell.date, standardID: standard.id)

                                        let baseOpacity = cell.isFuture ? 0.0 : 0.15 * opacity(for: cell.date)

                                        let fillColor: Color = {
                                            if cell.isFuture { return .clear }

                                            switch status {
                                            case .done:
                                                return Color(red: 0.15, green: 0.95, blue: 0.55)

                                            case .missed:
                                                return Color(red: 0.95, green: 0.25, blue: 0.35)

                                            default:
                                                return Color.white.opacity(baseOpacity)
                                            }
                                        }()

                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(fillColor)
                                            .overlay {
                                                if cell.isToday {
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .stroke(Color.white.opacity(0.45), lineWidth: 0.8)
                                                        .shadow(color: Color.white.opacity(0.18), radius: 1.8)
                                                }
                                            }
                                            .frame(width: 9, height: 9)
                                    }
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

        for (columnIndex, column) in grid.enumerated() {

            // Find if this column contains the 1st day of any month
            if let firstOfMonthCell = column.first(where: {
                calendar.component(.day, from: $0.date) == 1
            }) {

                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"

                labels.append(
                    MonthLabel(
                        text: formatter.string(from: firstOfMonthCell.date),
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

    private func weekdayLabel(for row: Int) -> String? {
        switch row {
        case 0: return "Mon"
        case 2: return "Wed"
        case 4: return "Fri"
        default: return nil
        }
    }

}
