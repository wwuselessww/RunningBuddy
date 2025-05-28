//
//  WorkoutDetails.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.05.25.
//

import SwiftUI

struct WorkoutDetails: View {
    @StateObject var vm = WorkOutDetailsViewModel()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Canvas {context, size in
                    var path = Path()
                    path.move(to: vm.pointArray[0])
                    path.addCurve(
                        to: vm.pointArray[1],
                        control1: CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.4),
                        control2: CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.4)
                    )
                    path.addCurve(
                        to: vm.pointArray[2],
                        control1: CGPoint(x: geo.size.width * 1, y: geo.size.height * 0.5),
                        control2: CGPoint(x: geo.size.width * 0.9, y: geo.size.height * 0.9)
                    )
                    context.stroke(path, with: .color(.black), style: .init(lineWidth: 6, lineCap: .round, dash: [10]))
                }
                VStack {
                    HStack {
                        Text("Start")
                            .track(index: 0)
                        Spacer()
                    }
                    Spacer()
                    Text("Center")
                        .frame(width: 100, height: 100)
                        .track(index: 1)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Finish")
                            .track(index: 2)
                    }
                }
                
            }
            .coordinateSpace(name: "WorkoutDetailsSpace")
            .onPreferenceChange(UpdateArray.self) { preferences in
                for pref in preferences {
                    if vm.viewFrames.indices.contains(pref.index) {
                        vm.viewFrames[pref.index] = pref.frame
                    }
                }
                vm.getPoints()
            }
        }
    }
}

#Preview {
    Circle()
    Spacer()
    WorkoutDetails()
}


//path.addArc(center: CGPoint(x: 200, y: 100), radius: 60, startAngle: .degrees(0), endAngle: .degrees(70), clockwise: false)
