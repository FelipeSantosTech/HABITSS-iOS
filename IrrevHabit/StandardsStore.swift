//
//  StandardsStore.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import Foundation
import Combine
import SwiftUI

class StandardsStore: ObservableObject {
    @Published var standards: [Standard] = []
    @Published var hasCompletedOnboarding: Bool = false
    @Published var areStandardsLocked: Bool = false
    
    @AppStorage("lastExecutionDate")
    private var lastExecutionDate: Double = 0
    
    var canLockStandards: Bool {
        !standards.isEmpty && !areStandardsLocked
    }
    
    func lockStandards (){
        guard canLockStandards else { return }
        areStandardsLocked = true
        resetForNewDayIfNeeded()
    }
    
    func resetForNewDayIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = Date(timeIntervalSince1970: lastExecutionDate)
        
        guard !Calendar.current.isDate(today, inSameDayAs: lastDate) else {
            return
        }
        
        
        for index in standards.indices {
            if standards[index].status == .pending {
                standards[index].status = .missed
            }
        }
        
        for index in standards.indices{
            standards[index].status = .pending
        }
        
        lastExecutionDate = today.timeIntervalSince1970
    }
    
    func markDone(at index: Int) {
        guard standards[index].status == .pending else {return}
        standards[index].status = .done
    }
    
    func markMissed(at index: Int) {
        guard standards[index].status == .pending else {return}
        standards[index].status = .missed
    }
}
