//
//  WorkoutInfo.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import SwiftUI
import MapKit
import Charts

struct WorkoutInfo: View {
    let splitArray: [Split] = [
        .init(splitNumber: 1, timeInSplit: 1.0, color: .blue),
        .init(splitNumber: 2, timeInSplit: 2.0, color: .green),
        .init(splitNumber: 3, timeInSplit: 6.0, color: .yellow),
        .init(splitNumber: 4, timeInSplit: 4.0, color: .orange),
        .init(splitNumber: 5, timeInSplit: 1.0, color: .red)
    ]
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Map()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .ignoresSafeArea()
                    .frame(height: geo.size.height / 2)
                Group {
                    Text("Saturday 25, 2025")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.bottom, 3)
                    WeatherConditions(temperature: 10, windSpeed: 10, humidity: 10)
                        .padding(.bottom, 15)
                    Grid(alignment: .leading) {
                        GridRow {
                            InfoCell(title: "Time", data: "00:00:00")
                            Spacer()
                            InfoCell(title: "Distance", data: "00:00:00")
                            Spacer()
                            InfoCell(title: "Max Hearth Rate", data: "00:00:00")
                            
                        }
                        GridRow {
                            InfoCell(title: "Active Energy", data: "00:00:00")
                            Spacer()
                            InfoCell(title: "Pace", data: "00:00:00")
                            Spacer()
                            InfoCell(title: "Avg Hearth Rate", data: "00:00:00")
                        }
                    }
                    .frame(height: 100)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Splits")
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
    }
}
#Preview {
    WorkoutInfo()
}

struct Split: Identifiable {
    var id = UUID()
    var splitNumber: Int
    var timeInSplit: Float
    var color: Color
    
}
