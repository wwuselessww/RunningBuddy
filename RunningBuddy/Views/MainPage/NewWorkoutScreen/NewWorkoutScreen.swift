//
//  NewWorkoutScreen.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 02.03.26.
//

import SwiftUI

struct NewWorkoutScreen: View {
    @State var vm: NewWorkoutModel = NewWorkoutModel()
    @State var emotion: Emotion = .easy
    var body: some View {
        VStack {
            Picker("lel", selection: $vm.selectedWorkoutType) {
                ForEach(vm.workoutTypesArray, id: \.self) { type in
                    Text(type.displayName)
                }
                
                
            }
            .pickerStyle(.segmented)
//            Face(emotion: $emotion)
                .padding(.all)
            
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NewWorkoutScreen()
}



