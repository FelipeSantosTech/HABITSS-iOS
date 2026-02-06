//
//  Date+PaywallFormatting.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 06/02/26.
//

import Foundation

extension Date {

    func paywallFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
