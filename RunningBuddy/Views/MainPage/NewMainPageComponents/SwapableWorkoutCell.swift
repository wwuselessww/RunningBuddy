//
//  SwapableWorkoutCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 31.03.26.
//

import SwiftUI

struct SwapableWorkoutCell: View {
    var workout: HKWorkoutModel
    @State private var offset: CGFloat = 0
    @State private var isShown: Bool = false
    var action: () -> Void
    
    init(workout: HKWorkoutModel, onDelete: @escaping () -> Void) {
        self.workout = workout
        self.action = onDelete
        
    }
    
    private let maxOffset: CGFloat = 80
    @GestureState private var translation: CGFloat = 0
    var body: some View {
        ZStack {
            if isShown {
                HStack {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundStyle(.red)
                            .padding()
                            .glassEffect(.regular.interactive().tint(.white))
                            .shadow(radius: 2)
                    }
                    .padding(.leading, 50)
                    Spacer()
                }
            }
            
            NewWorkoutCell(model: workout)
                .padding(.all)
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 500, maxHeight: 500)
                .offset(x: offset + translation)
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .updating($translation) { value, state, _ in
                            guard abs(value.translation.width) > abs(value.translation.height) else { return }
                            let delta = value.translation.width
                            state = delta
                            withAnimation {
                                isShown = delta > 150
                            }
                        }
                        .onEnded { value in
                            guard abs(value.translation.width) > abs(value.translation.height) else { return }
                            let delta = value.translation.width
                            offset += delta
                            withAnimation {
                                if offset > 150 {
                                    offset = 150
                                    isShown = true
                                } else {
                                    offset = 0
                                    isShown = false
                                }
                            }
                        }
                )
        }
    }
}

#Preview {
    let workout: HKWorkoutModel = .init(date: Date.now, distance: 10, type: .outdoorRun)
    VStack {
        ScrollView {
            SwapableWorkoutCell(workout: workout) {
                print("kek")
            }
            SwapableWorkoutCell(workout: workout) {
                
            }
            SwapableWorkoutCell(workout: workout) {
                
            }
        }
    }
}
