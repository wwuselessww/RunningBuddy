//
//  WorkoutPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct WorkoutPage: View {
    @StateObject var vm = WorkoutViewModel()
    var body: some View {
        VStack {
            Text(vm.selectedDifficulty.image)
                //FIXME: animation for changeing emoji
                .font(.system(size: 200))
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                .background {
                    vm.selectedDifficulty.color
                        .animation(.easeInOut)
                        .ignoresSafeArea()
                }
            Group {
                Picker("selection of difficulty", selection: $vm.selectedDifficulty) {
                    ForEach(vm.difficultyArray, id: \.self) { difficulty in
                        Text(difficulty.level)
                    }
                }
                .pickerStyle(.segmented)
                WorkoutDetails()
//                Spacer()
                Button {
                    print("press")
                } label: {
                    Text("Start")
                }

            }
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    WorkoutPage()
}
