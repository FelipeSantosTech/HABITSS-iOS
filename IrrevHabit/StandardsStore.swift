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
    @Published var hasCompletedOnboarding: Bool = false
    @Published var areStandardsLocked: Bool = false
    
    var canLockStandards: Bool {
        !standards.isEmpty && !areStandardsLocked
    }
    
    func lockStandards (){
        guard canLockStandards else { return }
        areStandardsLocked = true
    }
}
