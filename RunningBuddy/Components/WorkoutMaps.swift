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
                WorkoutSection(repeats: 0) {
                    Text("\(Int(startingBlock.time / 60)) minutes \(startingBlock.type.localizedName)")
                        .contentTransition(.numericText())
                }
            } centerView: {
                WorkoutSection(repeats: vm.numberOfRepeats) {
                    VStack(alignment: .leading) {
                        ForEach(vm.mainBlock, id: \.id) { section in
                            Text("\(Int(section.time / 60)) minutes \(section.type.localizedName)")
                                .contentTransition(.numericText())
                        }
                    }
                }
            } finishView: {
                WorkoutSection(repeats: 0) {
                    Text("\(Int(endBlock.time / 60)) minutes \(endBlock.type.localizedName)")
                        .contentTransition(.numericText())
                }
            }
        } else {
            Spacer()
        }
    }
}

#Preview {
    WorkoutMaps(vm: .constant(WorkoutViewModel()))
}


