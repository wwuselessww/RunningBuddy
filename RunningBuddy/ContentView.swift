//
//  ContentView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct ContentView: View {
    //MARK: For debuging
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @State var currentView: any View = MainPage()
    var body: some View {
        ZStack {
            if isOnboardingCompleted {
                    TabView {
                        Tab("home", systemImage: "house", role: .none) {
                            MainPage()
                        }
                        Tab("Workout", systemImage: "figure.run", role: .none) {
                            WorkoutPage()
                        }
                        Tab("Profile", systemImage: "person.fill", role: .none) {
                            SettingsPage()
                        }
                        Tab("Debug", systemImage: "ladybug", role: .none) {
                            DebugPage()
                        }
                    }
            } else {
                OnboardingRoot()
                    
            }
            
        }
        .task {
            await HealthKitManager.shared.requestAuthorization()
        }
        .environment(\.managedObjectContext, WorkoutProvider.shared.viewContext)
    }
}

#Preview {
    ContentView()
}
