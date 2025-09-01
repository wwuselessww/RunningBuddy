//
//  ContentView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
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
               
            }
        }
        .environment(\.managedObjectContext, WorkoutProvider.shared.viewContext)
        .onAppear {
            HealthKitManager.shared.ensuresHealthKitSetup()
            print("Healt1")
        }
    }
}

#Preview {
    ContentView()
}
