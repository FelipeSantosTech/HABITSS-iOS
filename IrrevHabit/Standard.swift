//  Standard.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import Foundation

struct Standard: Identifiable {
    let id = UUID()
    let title: String
    var isDoneToday: Bool = false
}
