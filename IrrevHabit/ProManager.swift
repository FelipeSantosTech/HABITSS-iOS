//
//  ProManager.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 02/02/26.
//

import SwiftUI
import Combine

@MainActor
class ProManager: ObservableObject {

    // MARK: - Source of Truth

    @Published var isProUser: Bool = false

    // MARK: - DEV ONLY (Remove Later)

    func enableProForDebug() {
        isProUser = true
    }

    func disableProForDebug() {
        isProUser = false
    }
}
