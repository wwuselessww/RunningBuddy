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
    @ObservedObject var vm: FinishWorkoutViewModel
    @Binding var path: NavigationPath
    init(isRecordedByWatch: Bool = false, workout: WorkoutResultsModel?, path: Binding<NavigationPath>) {
        self._path = path
        self.isRecordedByWatch = isRecordedByWatch
        self.workout = workout
        print("workout", workout)
        print("self.workout", self.workout)
        self.vm = .init(provider: .shared)
        self.vm.result = workout
        vm.formatResultData()
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
           .toolbar(.hidden, for: .tabBar)
           .navigationTitle("Outdoor Run")
           .toolbar {
               ToolbarItem(id: "Finish workout", placement: .topBarTrailing) {
                   Button {
                       print("Finish")
                       do {
                           try vm.saveWorkout()
                           print("saved")
                           path = NavigationPath()
                       } catch {
                           print(error)
                       }
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
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        FinishWorkout(isRecordedByWatch: false, workout: .init(pace: 10, distance: 10, duration: 0, path: [], calories: 10, avgHeartRate: 10, maxHeartRate: 10), path: $path)
    }
}
