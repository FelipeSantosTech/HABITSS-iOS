//
//  ProTabView.swift .swift
//  HABITSS
//
//  Created by Paulo Marcelo Santos on 02/02/26.
//

import SwiftUI

struct ProTabView: View {
    
    @EnvironmentObject var proManager: ProManager
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    ProStatusHeader(isPro: proManager.isProUser)
                    
                    ProToolsSection()
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
        }
    }
}

struct ProStatusHeader: View {
    
    let isPro: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(isPro ? "PRO ENABLED" : "Upgrade to Pro")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
            
            Text(isPro
                 ? "Advanced discipline tools unlocked"
                 : "Unlock advanced discipline tools")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.bottom, 8)
    }
}


struct ProToolsSection: View {
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            
            ProToolCard(
                icon: "lock.iphone",
                title: "App Blocking",
                subtitle: "Lock distractions until standards are complete"
            )
            
            ProToolCard(
                icon: "slider.horizontal.3",
                title: "Flexible Habits",
                subtitle: "Temporary habits and advanced editing"
            )
        }
    }
}

struct ProToolCard: View {
    
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

