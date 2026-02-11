//
//  ProHeaderView.swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 11/02/26.
//
//     if



import SwiftUI

struct ProHeaderView: View {
    
    @EnvironmentObject var proManager: ProManager
    
    var body: some View {
          ScreenHeader(
              eyebrow: eyebrowText,
              title: titleText,
          )
      }
      
      // MARK: - Computed Text
      
      private var eyebrowText: String {
          "Pro \(proManager.isProUser ? "🔓" : "🔒")"
      }
      
      private var titleText: String {
          if proManager.isProUser {
              return "Advanced discipline controls"
          } else {
              return "Unlock advanced discipline controls"
          }
      }
}

