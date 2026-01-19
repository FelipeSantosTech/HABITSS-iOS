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
    @Published var history: [DailyRecord] = [] {
        didSet {
            dailyHistoryData = (try? JSONEncoder().encode(history)) ?? Data()
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
        loadHistory()
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
        // ✅ Then: reset all standards for the new day
        for index in standards.indices {
            standards[index].status = .pending
        }

        lastExecutionDate = today.timeIntervalSince1970
    }
    
    func logStandard(_ standard: Standard) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Remove existing record for this habit today (overwrite)
        history.removeAll {
            $0.standardID == standard.id &&
            calendar.isDate($0.date, inSameDayAs: today)
        }

        let record = DailyRecord(
            date: today,
            standardID: standard.id,
            status: standard.status
        )

        history.append(record)
    }

    
    func markDone(at index: Int) {
        guard standards[index].status == .pending else { return }

        standards[index].status = .done
        logStandard(standards[index])
    }


    func markMissed(at index: Int) {
        guard standards[index].status == .pending else { return }

        standards[index].status = .missed
        logStandard(standards[index])
    }


    private func loadHistory() {
        guard
            let decoded = try? JSONDecoder().decode([DailyRecord].self, from: dailyHistoryData)
        else {
            return
        }

        history = decoded
    }

}

