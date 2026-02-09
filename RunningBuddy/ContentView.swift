//
//  ContentView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct ContentView: View {
    //MARK: For debuging
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = true
    @State var currentView: any View = NewMainPage()
    var body: some View {
        ZStack {
            if isOnboardingCompleted {
                if #available(iOS 26, *) {
                    TabView {
                        Tab("home", systemImage: "house", role: .none) {
                            NewMainPage()
                        }
                        Tab("Workout", systemImage: "figure.run", role: .none) {
                            WorkoutPage()
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
        .environment(\.managedObjectContext, WorkoutProvider.shared.viewContext)
//        .onAppear {
//            HealthKitManager.shared.ensuresHealthKitSetup()
//        }
    }
}

#Preview {
    ContentView()
}
