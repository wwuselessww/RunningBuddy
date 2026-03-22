//
//  WorkoutMaps.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 16.03.26.
//

import SwiftUI

struct WorkoutMaps: View {
    @Binding var vm: WorkoutViewModel
    
    var body: some View {
        if let startingBlock = vm.startingBlock, let endBlock = vm.endBlock {
            WorkoutDetails {
                AnyView(
                    WorkoutSection(repeats: 0, {
                        Text("^[\(Int(startingBlock.time / 60)) minutes](inflect: true) \(startingBlock.type.rawValue)")
                            .contentTransition(.numericText())
                        
                    })
                )
            } centerView: {
                AnyView (
                    WorkoutSection(repeats: vm.numberOfRepeats, {
                        VStack(alignment: .leading) {
                            ForEach(vm.mainBlock, id: \.self) { section in
                                Text("^[\(Int(section.time / 60)) minutes](inflect: true) \(section.type.rawValue)")
                            }
                        }
                    })
                    .contentTransition(.numericText())
                )
            } finishView: {
                AnyView(
                    WorkoutSection(repeats: 0, {
                        Text("^[\(Int(endBlock.time / 60)) minutes](inflect: true) \(endBlock.type.rawValue)")
                    })
                )
            }
        } else {
            Spacer()
        }
    }
}

#Preview {
    WorkoutMaps(vm: .constant(WorkoutViewModel()))
}
