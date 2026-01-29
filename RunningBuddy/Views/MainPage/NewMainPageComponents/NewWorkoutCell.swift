//
//  NewActivityCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.01.26.
//

import SwiftUI
import MapKit

struct NewWorkoutCell: View {
    @StateObject var vm = WorkoutInfoViewModel()
    let model: HKWorkoutModel
    var body: some View {
        ZStack {
            if vm.isLoading {
                ProgressView()
            } else if vm.locationsArray.isEmpty {
                Text("no route")
            } else {
                Map {
                    let coords = vm.locationsArray.map{$0.coordinate}
                    MapPolygon(coordinates: coords)
                        .stroke(.blue, lineWidth: 5)
                }
                .overlay {
                    LinearGradient(colors: [.white.opacity(0.1), .white], startPoint: .top, endPoint: .bottom)
                }
            }
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(model.type.rawValue)
                            .font(.title.bold())
                    }
                    Spacer()
                    
                }
                .padding(.top)
                .padding(.horizontal)
                Spacer()
                if model.recordedByPhone {
                    VStack {
                        HStack {
                            InfoCell(title: "Time", data: vm.timeString, dataColor: .label)
                            Spacer()
                            InfoCell(title: "Distance", data: vm.distanceString, dataColor: .label)
                            Spacer()
                            InfoCell(title: "Pace", data: vm.paceString, dataColor: .label)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                } else {
                    VStack {
                        HStack {
                            InfoCell(title: "Time", data: vm.timeString, dataColor: .label)
                            Spacer()
                            InfoCell(title: "Distance", data: vm.distanceString, dataColor: .label)
                            Spacer()
                            InfoCell(title: "Max Hearth Rate", data: vm.maxHearthRateString, dataColor: .label)
                        }
                        .padding(.horizontal)
                        HStack {
                            InfoCell(title: "Active Energy", data: vm.activeEnergyString, dataColor: .label)
                            Spacer()
                            InfoCell(title: "Pace", data: vm.paceString, dataColor: .label)
                            Spacer()
                            InfoCell(title: "Avg Hearth Rate", data: vm.avgHearthRateString, dataColor: .label)
                        }
                        .padding()
                    }
                    .padding(.bottom)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .onAppear {
            vm.getDateInString(date: model.date)
            vm.workoutModel = model
            Task {
                await vm.getWorkoutData()
                await vm.getWorkoutPath()
                await vm.getZones()
                vm.foodBurned = vm.calculateBurnedCaloriesInFood(caloriee: Int(vm.activeEnergyString) ?? 0)
            }
            
        }
        
    }
}

#Preview {
    let model: HKWorkoutModel = .init(date: Date.now, distance: 10, type: .outdoorRun, recordedByPhone: false)
    NewWorkoutCell(model: model)
        .frame(height: 400)
        .padding()
}
