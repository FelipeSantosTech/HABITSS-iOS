//  ContentView.swift
//  IrrevHabit
//  Created by Paulo Marcelo Santos on 23/12/25.
import SwiftUI
struct ContentView: View {
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                
                Spacer()
                
                VStack(spacing:24){
                    
                    VStack(spacing:12){
                        Text("IRREV does not motivate you")
                        Text("It records what you actually do")
                        Text("Misses are permanent")
                    }
                    
                    Text("ARE YOU READY TO SEE THE TRUTH AND CHANGE YOUR REALITY?")
                        .font(.headline)
                    
                    Button("YES"){
                        print("Yes tapped")
                    }
                    
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                }
                .foregroundColor(.white)
                .font(.system(.body, design: .monospaced))
                
                Spacer()
            }
            .padding(24)
        }
    }
}
#Preview {
    ContentView()
}
