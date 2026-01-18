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
    @AppStorage("standardsData")
    private var standardsData: Data = Data()
    @AppStorage("dailyHistory")
    private var dailyHistoryData: Data = Data()
    @Published var standards: [Standard] = [] {
        didSet {
            persistStandards()
        }
    }
    
    @Published var hasCompletedOnboarding: Bool = false
    @AppStorage("areStandardsLocked")
    var areStandardsLocked: Bool = false
    
    let maxStandards = 5

    var canAddStandard: Bool {
        standards.count < maxStandards && !areStandardsLocked
    }
    private func persistStandards() {
        standardsData = (try? JSONEncoder().encode(standards)) ?? Data()
    }

    private func loadStandards() {
        guard
            let decoded = try? JSONDecoder().decode([Standard].self, from: standardsData)
        else {
            return
        }
        standards = decoded
    }
    init() {
        loadStandards()
    }


    func addStandard(title: String) {
        guard canAddStandard else { return }

        let standard = Standard(
            id: UUID(),
            title: title,
            status: .pending
        )

        standards.append(standard)
    }

    
    @AppStorage("lastExecutionDate")
    private var lastExecutionDate: Double = 0
    
    var canLockStandards: Bool {
        !standards.isEmpty && !areStandardsLocked
    }
    
    var isDayComplete: Bool {
        standards.allSatisfy{
            standard in standard.status != DailyStatus.pending
        }
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
        logTodayIfNeeded()

        for index in standards.indices{
            standards[index].status = .pending
        }
        
        lastExecutionDate = today.timeIntervalSince1970
    }
    func logTodayIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Prevent double logging for the same day
        let alreadyLogged = dailyHistory.contains {
            calendar.isDate($0.date, inSameDayAs: today)
        }

        guard !alreadyLogged else { return }

        var newRecords: [DailyRecord] = []

        for standard in standards {
            guard standard.status != .pending else { continue }

            let record = DailyRecord(
                date: today,
                standardID: standard.id,
                status: standard.status
            )

            newRecords.append(record)
        }

        dailyHistory.append(contentsOf: newRecords)
    }

    var history: [DailyRecord] {
        dailyHistory
    }
    
    func markDone(at index: Int) {
        guard standards[index].status == DailyStatus.pending else { return }
        _ = standards[index].status.rawValue
        standards[index].status = .done
    
        if isDayComplete {
            logTodayIfNeeded()
        }
    }

    func markMissed(at index: Int) {
        guard standards[index].status == DailyStatus.pending else { return }
        _ = standards[index].status.rawValue
        standards[index].status = .missed

        if isDayComplete {
            logTodayIfNeeded()
        }
    }

    
    private var dailyHistory: [DailyRecord] {
        get {
            guard
                let decoded = try? JSONDecoder().decode([DailyRecord].self, from: dailyHistoryData)
            else {
                return []
            }
            return decoded
        }
        set {
            dailyHistoryData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
        
    }
}

