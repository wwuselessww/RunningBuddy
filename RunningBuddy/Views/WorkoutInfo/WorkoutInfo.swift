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
    let splitArray: [Split] = [
        .init(splitNumber: 1, timeInSplit: 1.0, color: .blue),
        .init(splitNumber: 2, timeInSplit: 2.0, color: .green),
        .init(splitNumber: 3, timeInSplit: 6.0, color: .yellow),
        .init(splitNumber: 4, timeInSplit: 4.0, color: .orange),
        .init(splitNumber: 5, timeInSplit: 1.0, color: .red)
    ]
    
    @StateObject var vm = WorkoutInfoViewModel()
    @Binding var workoutModel: WorkoutModel
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                Map {
                    if !vm.locationsArray.isEmpty {
                        let coords = vm.locationsArray.map{$0.coordinate}
                        MapPolyline(coordinates: coords)
                            .stroke(.blue, lineWidth: 5)
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
                                ForEach(splitArray) { split in
                                    BarMark(
                                        x: .value("kek", split.splitNumber),
                                        y: .value("heh", split.timeInSplit),
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
                            Text("🥤🍔")
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
            }
        }
    }
}

struct Split: Identifiable {
    var id = UUID()
    var splitNumber: Int
    var timeInSplit: Float
    var color: Color
    
}

