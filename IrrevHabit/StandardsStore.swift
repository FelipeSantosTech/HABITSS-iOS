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
    @AppStorage("historyData")
    private var historyData: Data = Data()
    @Published var standards: [Standard] = [] {
        didSet {
            persistStandards()
        }
    }
    @Published var hasCompletedOnboarding: Bool = false
    @Published var areStandardsLocked: Bool = false
    
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
        // #region agent log
        AgentDebugLog.log(
            runId: "baseline",
            hypothesisId: "H1/H3",
            location: "StandardsStore.swift:init",
            message: "Store initialized",
            data: [
                "standardsCount": standards.count,
                "areStandardsLocked": areStandardsLocked,
                "hasCompletedOnboarding": hasCompletedOnboarding,
                "standardsDataBytes": standardsData.count,
                "dailyHistoryDataBytes": dailyHistoryData.count,
                "historyDataBytes": historyData.count,
                "historyComputedCount": history.count
            ]
        )
        // #endregion
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
        // #region agent log
        AgentDebugLog.log(
            runId: "baseline",
            hypothesisId: "H1",
            location: "StandardsStore.swift:lockStandards",
            message: "Standards locked",
            data: ["standardsCount": standards.count, "areStandardsLocked": areStandardsLocked]
        )
        // #endregion
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
        let today = Calendar.current.startOfDay(for: Date())

        // Prevent double logging
        let alreadyLogged = dailyHistory.contains {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }

        guard !alreadyLogged else { return }

        let newHistory = dailyHistory

        func mark(_ standard: Standard, as status: DailyStatus) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())

            // Remove existing record for today & standard
            dailyHistory.removeAll {
                calendar.isDate($0.date, inSameDayAs: today)
                && $0.standardID == standard.id
            }

            // Add new record
            let record = DailyRecord(
                id: UUID(),
                date: today,
                standardID: standard.id,
                status: status
            )

            dailyHistory.append(record)
            persistHistory()
        }


        dailyHistory = newHistory
        // #region agent log
        AgentDebugLog.log(
            runId: "baseline",
            hypothesisId: "H2/H3",
            location: "StandardsStore.swift:logTodayIfNeeded",
            message: "Attempted to log today",
            data: [
                "alreadyLogged": alreadyLogged,
                "standardsCount": standards.count,
                "isDayComplete": isDayComplete,
                "dailyHistoryCountAfter": dailyHistory.count,
                "historyComputedCountAfter": history.count
            ]
        )
        // #endregion
    }
    var history: [DailyRecord] {
        dailyHistory
    }
    private func persistHistory() {
        historyData = (try? JSONEncoder().encode(dailyHistory)) ?? Data()
    }

    private func loadHistory() {
        guard
            let decoded = try? JSONDecoder().decode([DailyRecord].self, from: historyData)
        else {
            return
        }

        dailyHistory = decoded
    }


    
    func markDone(at index: Int) {
        guard standards[index].status == DailyStatus.pending else { return }
        let before = standards[index].status.rawValue
        standards[index].status = .done
        // #region agent log
        AgentDebugLog.log(
            runId: "baseline",
            hypothesisId: "H2",
            location: "StandardsStore.swift:markDone",
            message: "Marked done",
            data: [
                "index": index,
                "before": before,
                "after": standards[index].status.rawValue,
                "isDayComplete": isDayComplete
            ]
        )
        // #endregion

        if isDayComplete {
            logTodayIfNeeded()
        }
    }

    func markMissed(at index: Int) {
        guard standards[index].status == DailyStatus.pending else { return }
        let before = standards[index].status.rawValue
        standards[index].status = .missed
        // #region agent log
        AgentDebugLog.log(
            runId: "baseline",
            hypothesisId: "H2",
            location: "StandardsStore.swift:markMissed",
            message: "Marked missed",
            data: [
                "index": index,
                "before": before,
                "after": standards[index].status.rawValue,
                "isDayComplete": isDayComplete
            ]
        )
        // #endregion

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
