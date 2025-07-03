//
//  ContentView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 18, *) {
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
            .onAppear {
                HealthKitManager.shared.ensuresHealthKitSetup()
                print("healt 2")
            }
        } else {
            TabView {
                MainPage()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                WorkoutPage()
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Workout")
                    }
                ProgressPage()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis.ascending")
                        Text("Progress")
                        
                    }
            }
            .onAppear {
                HealthKitManager.shared.ensuresHealthKitSetup()
                print("Healt1")
            }
        }
    }
}

#Preview {
    ContentView()
}
