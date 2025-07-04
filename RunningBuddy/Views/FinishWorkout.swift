//
//  FinishWorkout.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 18.06.25.
//

import SwiftUI
import MapKit
struct FinishWorkout: View {
    var isRecordedByWatch: Bool
    var workout: WorkoutResultsModel?
    @StateObject var vm = FinishWorkoutViewModel()
    
    init(isRecordedByWatch: Bool = false, workout: WorkoutResultsModel?) {
        self.isRecordedByWatch = isRecordedByWatch
        self.workout = workout
    }
    
    var body: some View {
       if let workout = self.workout {
           ZStack(alignment: .leading) {
               Map{
                   
               }
               .ignoresSafeArea(.all)
                   VStack(alignment: .leading) {
                       Spacer()
                       Text(vm.dateString)
                           .font(.title)
                           .fontWeight(.semibold)
                           HStack {
                               InfoCell(title: "Time", data: "\(vm.timeString)")
                               Spacer()
                               InfoCell(title: "Distance", data: "\(vm.distanceString) km")
                               Spacer()
                               InfoCell(title: "Pace", data: "\(vm.paceString) km/h")
                           }
                           if isRecordedByWatch {
                               HStack {
                                   InfoCell(title: "Max HR", data: "BPM")
                                   Spacer()
                                   InfoCell(title: "Avg HR", data: "10 BPM")
                                   Spacer()
                                   InfoCell(title: "Calories", data: "100")
                               }
                           }
                       
                   }
                   .padding(.horizontal)
                   .background {
                       RoundedRectangle(cornerRadius: 10)
                           .foregroundStyle(.white)
                           .mask(
                               LinearGradient(colors: [.white, .white.opacity(0.5),.white.opacity(0)], startPoint: .bottom, endPoint: .top)
                           )
                           .ignoresSafeArea()
                   }
               .allowsHitTesting(false)
           }
           .onAppear {
               vm.result = workout
               vm.formatResultData()
           }
           .toolbar(.hidden, for: .tabBar)
           .navigationTitle("Outdoor Run")
           .toolbar {
               ToolbarItem(id: "Finish workout", placement: .topBarTrailing) {
                   Button {
                       print("Finish")
                       vm.saveWorkout()
                   } label: {
                       HStack {
                           Text("Finish")
                       }
                   }

               }
           }
       } else {
           VStack {
               ProgressView()
               Text("Loading...")
           }
       }
        
    }
}

#Preview {
    NavigationStack {
        FinishWorkout(isRecordedByWatch: false, workout: .init(pace: 10, distance: 10, duration: 0, path: [], calories: 10, avgHeartRate: 10, maxHeartRate: 10))
    }
}
