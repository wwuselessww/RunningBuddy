//
//  ScrollingButtons.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 19.03.26.
//

import SwiftUI

struct ScrollingButtons: View {
    @Binding var selectedType: WorkoutDifficulty
    @Binding var scrollId: Emotion?
    let workoutTypes: [WorkoutDifficulty]
    var time: Int
    var action: () -> Void
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Total time: \(time / 60) min")
                    .contentTransition(.numericText())
                    .font(.default)
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.background.opacity(0.5))
                            
                    }
                Spacer()
            }
            
            HStack {
                GeometryReader { geo in
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(workoutTypes, id: \.id) { data in
                                
                                Button {
                                    selectedType = data
                                    print(selectedType)
                                    action()
                                } label: {
                                    Text(data.level.capitalized)
                                        .font(.title)
                                        .foregroundStyle(.reverserLabel)
                                        .frame(width: geo.size.width / 1.0, height: 50)
                                        .glassEffect(.regular.tint(data.color).interactive())
                                }
                                .id(data.image )
                            }
                        }
                    }
                    .scrollPosition(id: $scrollId)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollTargetLayout()
                    .scrollClipDisabled()
                }
            }
        }
        .padding(.horizontal)
        .fontDesign(.rounded)
        .fontWeight(.medium)
    }
}

#Preview {
    @Previewable @State var selected: WorkoutDifficulty = .init(level: "s", image: .easy, color: .red)
    @Previewable @State var array: [WorkoutDifficulty] = [
        .init(level: "easy", image: .easy, color: .green),
        .init(level: "mid", image: .mid, color: .yellow),
        .init(level: "hard", image: .hard, color: .red),
    ]
    Spacer()
    ScrollingButtons(selectedType: $selected, scrollId: .constant(.easy), workoutTypes: array, time: 0) {
        print("heh")
    }
        .frame(height: 100)
    Spacer()
}
