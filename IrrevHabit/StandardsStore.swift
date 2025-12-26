//
//  StandardsStore.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import Foundation
import Combine

class StandardsStore: ObservableObject {
    @Published var standards: [Standard] = []
    
    @Published var isLocked: Bool = false
    
    func lockStandards() {
        isLocked = true
    }
}
