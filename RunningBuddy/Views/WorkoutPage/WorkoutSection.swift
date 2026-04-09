//
//  WorkoutSection.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 29.05.25.
//

import SwiftUI
struct WorkoutSection<Content:View>: View {
    
    var content: Content
    var repeats: Int
    init(repeats: Int, @ViewBuilder _ content: () -> Content) {
        self.repeats = repeats
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if repeats != 0 {
                    HStack(spacing: 0) {
                        Image(systemName: "repeat.circle")
                        Text("\(repeats) times")
                    }
                    .font(.callout)
                    .fontDesign(.rounded)
                    .contentTransition(.numericText())
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.reverserLabel)
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 2)
                                .foregroundStyle(.gray)
                        }
                    }
                
            }
            
            content
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 4)
                        .fill(.background)
                }
        }
        
    }
}

#Preview {
    WorkoutSection(repeats: 1) {
        VStack(alignment: .leading) {
            Text("4 minutes Run")
            Text("2 minutes Walk")
            Text("6 minutes Run")
            Text("2 minutes Walk")
        }
    }
}

#Preview {
    WorkoutSection(repeats: 0) {
        Text("6 minutes Run")
    }
}
