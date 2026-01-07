//
//  DailyRecord.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 03/01/26.
//


import Foundation

struct DailyRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let standardID: UUID
    let status: DailyStatus

    init(date: Date, standardID: UUID, status: DailyStatus) {
        self.id = UUID()
        self.date = date
        self.standardID = standardID
        self.status = status
    }
}

