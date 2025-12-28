//
//  MainView.swift
//  IrrevHabit
//
//  Created by Paulo Marcelo Santos on 24/12/25.
//

import SwiftUI
struct MainView: View {
    @EnvironmentObject var store: StandardsStore
    
    var body: some View {
        
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 32){
                //header
                VStack(spacing: 8) {
                    Text("EXECUTE")
                        .font(.caption)
                        .tracking(2)
                        .foregroundColor(.gray)
                    
                    Text("Today")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                //standards
                VStack(spacing: 16) {
                    ForEach(store.standards.indices, id: \.self) { index in
                        standardCard(for: index)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    @ViewBuilder
    private func standardCard(for index: Int) -> some View {
        let standard = store.standards[index]
        
        VStack(spacing: 16) {
            Text(standard.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if standard.status == .pending {
                HStack(spacing: 12) {
                    Button("DONE") {
                        markDone(index)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(6)
                    
                    Button("MISSED"){
                        markMissed(index)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(white: 0.2))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
            } else {
                Text(standard.status == .done ? "COMPLETED" : "MISSED")
                    .font(.caption)
                    .tracking(1)
                    .foregroundColor(standard.status == .done ? .green : .red)
            }
        }
        .padding()
        .background(Color(white: 0.08))
        .cornerRadius(8)
    }
    
    private func markDone (_ index: Int) {
        store.standards[index].status = .done
    }
    
    private func markMissed (_ index: Int) {
        store.standards[index].status = .missed
    }
}

#Preview {
    MainView()
        .environmentObject(StandardsStore())
}
