//  Standard.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import Foundation

struct Standard: Identifiable, Codable {
    let id: UUID
    let title: String
    let createdAt: Date
    let isLocked: Bool
}
