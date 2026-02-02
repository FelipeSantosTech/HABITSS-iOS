//
//  Standard.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 26/12/25.
//

import Foundation
 

enum DailyStatus: String, Codable {
    case pending
    case done
    case missed
}

enum HabitType: String, Codable {
    case superHabit
    case temporary
}

struct Standard: Identifiable, Codable {
    let id: UUID
    var title: String
    var status: DailyStatus
    var type: HabitType = .superHabit

    var isSuper: Bool {
        type == .superHabit
    }

    var isTemporary: Bool {
        type == .temporary
    }
}
