//
//  ContentView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
           
            Tab("home", systemImage: "house", role: .none) {
                MainPage()
            }
            Tab("Workout", systemImage: "figure.run", role: .none) {
                WorkoutPage()
            }
            Tab("Progress", systemImage: "chart.line.text.clipboard.fill", role: .none) {
                ProgressPage()
            }
                
        }
    }
}

#Preview {
    ContentView()
}
