//
//  NewActivityCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.01.26.
//

import SwiftUI
import MapKit

struct NewActivityCell: View {
//    let model: HKWorkoutModel = .init(date: Date.now, distance: 10, type: .outdoorRun, recordedByPhone: false)
    let model: HKWorkoutModel
    var body: some View {
        ZStack {
            Map {
                MapPolygon(coordinates: [.init(latitude: 44.82047531388908, longitude: 20.40543786125432)])
            }
            .overlay {
                LinearGradient(colors: [.white.opacity(0.1), .white], startPoint: .top, endPoint: .bottom)
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
                            InfoCell(title: "Time", data: "99:99:99", dataColor: .label)
                            Spacer()
                            InfoCell(title: "Distance", data: "0.37 km", dataColor: .label)
                            Spacer()
                            InfoCell(title: "Pace", data: "0.37 km", dataColor: .label)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    VStack {
                        HStack {
                            InfoCell(title: "Time", data: "99:99:99", dataColor: .label)
                            Spacer()
                            InfoCell(title: "Distance", data: "0.37 km", dataColor: .label)
                            Spacer()
                            InfoCell(title: "Max Hearth Rate", data: "0.37 km", dataColor: .label)
                        }
                        .padding(.horizontal)
                        HStack {
                            InfoCell(title: "Time", data: "99:99:99", dataColor: .label)
                            Spacer()
                            InfoCell(title: "Distance", data: "0.37 km", dataColor: .label)
                            Spacer()
                            InfoCell(title: "Avg Hearth Rate", data: "0.37 km", dataColor: .label)
                        }
                        .padding()
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        
    }
}

#Preview {
    let model: HKWorkoutModel = .init(date: Date.now, distance: 10, type: .outdoorRun, recordedByPhone: false)
    NewActivityCell(model: model)
        .frame(height: 400)
        .padding()
}
