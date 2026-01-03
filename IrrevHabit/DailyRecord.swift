//
//  DailyRecord.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 03/01/26.
//


import Foundation

struct DailyRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let standardID: UUID
    let status: DailyStatus
}
