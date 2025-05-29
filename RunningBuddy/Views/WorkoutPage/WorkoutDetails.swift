//
//  WorkoutDetails.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.05.25.
//

import SwiftUI

struct WorkoutDetails<Content: View>: View {
    @StateObject var vm = WorkOutDetailsViewModel()
    var startView: Content
    var centerView: Content
    var finishView: Content
    
    init(@ViewBuilder startView: () -> Content, @ViewBuilder centerView: () -> Content, @ViewBuilder finishView: () -> Content) {
        self.startView = startView()
        self.centerView = centerView()
        self.finishView = finishView()
    }
    
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
                        startView
                        .track(index: 0)
                        Spacer()
                    }
                    Spacer()
                        centerView
                        .track(index: 1)
                    Spacer()
                    HStack {
                        Spacer()
                        finishView
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
    WorkoutDetails {
        Text("starting here")
    } centerView: {
        Text("i am in the midle")
    } finishView: {
        Text("now at the finish line")
    }

}
