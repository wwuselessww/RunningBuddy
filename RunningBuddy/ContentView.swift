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
                if #available(iOS 26, *) {
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
//        .onAppear {
//            HealthKitManager.shared.ensuresHealthKitSetup()
//        }
    }
}

#Preview {
    ContentView()
}
