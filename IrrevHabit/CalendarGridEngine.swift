//
//  CalendarGridEngine.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 28/01/26.
//

import Foundation

struct CalendarGridEngine {

    static let weeksVisible = 24
    static let daysPerWeek = 7

    struct DayCell: Identifiable {
        let id = UUID()
        let date: Date
        let isToday: Bool
        let isFuture: Bool
    }


    /// Generates a 2D grid [column][row]
    /// Column = week (left → right)
    /// Row = weekday (top → bottom, Monday first)
    static func generateGrid(today: Date = Date()) -> [[DayCell]] {

        let calendar = Calendar.current

        // Force Monday as first weekday
        var mondayCalendar = calendar
        mondayCalendar.firstWeekday = 2

        // Find start of current week (Monday)
        let startOfThisWeek = mondayCalendar.dateInterval(of: .weekOfYear, for: today)!.start

        var grid: [[DayCell]] = []

        for weekOffset in stride(from: weeksVisible - 1, through: 0, by: -1) {

            guard let weekStart = mondayCalendar.date(
                byAdding: .weekOfYear,
                value: -weekOffset,
                to: startOfThisWeek
            ) else { continue }

            var column: [DayCell] = []

            for dayOffset in 0..<daysPerWeek {

                guard let date = mondayCalendar.date(
                    byAdding: .day,
                    value: dayOffset,
                    to: weekStart
                ) else { continue }

                let isToday = mondayCalendar.isDate(date, inSameDayAs: today)
                let isFuture = date > today

                column.append(
                    DayCell(
                        date: date,
                        isToday: isToday,
                        isFuture: isFuture
                    )
                )

            }

            grid.append(column)
        }

        return grid
    }
}
