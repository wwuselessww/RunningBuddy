//
//  WorkoutInfo.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import SwiftUI
import MapKit
import Charts
import HealthKit

struct WorkoutInfo: View {
    
    @StateObject var vm = WorkoutInfoViewModel()
    var workoutModel: HKWorkoutModel
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .leading) {
                    Group {
                        if vm.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            if vm.locationsArray.isEmpty {
                                VStack(alignment: .center) {
                                    Text("Hmmmm, no route for this workout? how queer!!!")
                                        .font(.system(size: 30, weight: .bold))
                                        .padding(.horizontal)
                                }
                            } else {
                                Map {
                                    let coords = vm.locationsArray.map{$0.coordinate}
                                    MapPolyline(coordinates: coords)
                                        .stroke(.blue, lineWidth: 5)
                                }
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .ignoresSafeArea()
                    .frame(height: geo.size.height / 2)
                Group {
                    Text(vm.dateSting)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.bottom, 3)
                    
                    Grid(alignment: .leading) {
                        GridRow {
                            InfoCell(title: "Time", data: vm.timeString)
                            Spacer()
                            InfoCell(title: "Distance", data: vm.distanceString)
                            Spacer()
                            InfoCell(title: "Max Hearth Rate", data: vm.maxHearthRateString)
                            
                        }
                        GridRow {
                            InfoCell(title: "Active Energy", data: vm.activeEnergyString)
                            Spacer()
                            InfoCell(title: "Pace", data: vm.paceString)
                            Spacer()
                            InfoCell(title: "Avg Hearth Rate", data: vm.avgHearthRateString)
                        }
                    }
                    .frame(height: 100)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hearth Rate Zones")
                                .font(.system(size: 20, weight: .bold))
                            Chart {
                                ForEach(vm.splitArray) { split in
                                    BarMark(
                                        x: .value("Zone", split.splitNumber),
                                        y: .value("Time in zone", split.timeInSplit),
                                        width: 36
                                        
                                    )
                                    .annotation(overflowResolution: .automatic, content: {
                                        Text(String(format: "%.1f", split.timeInSplit))
                                    })
                                    .foregroundStyle(split.color.gradient)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        Spacer()
                        VStack {
                            Text("Burned")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Text(vm.foodBurned)
                                .font(.system(size: 48))
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            vm.getDateInString(date: workoutModel.date)
            vm.workoutModel = workoutModel
            Task {
                await vm.getWorkoutData()
                await vm.getWorkoutPath()
                await vm.getZones()
                vm.foodBurned = vm.calculateBurnedCaloriesInFood(caloriee: Int(vm.activeEnergyString) ?? 0)
            }
        }
    }
}



