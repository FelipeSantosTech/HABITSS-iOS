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

struct Standard: Identifiable, Codable {
    let id: UUID
    let title: String
    var status: DailyStatus
}
