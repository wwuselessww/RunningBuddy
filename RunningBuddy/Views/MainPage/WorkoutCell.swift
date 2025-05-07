//
//  WorkoutCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI

struct WorkoutCell: View {
    var workoutType: WorkoutType
    var body: some View {
        HStack {
            Image(systemName: workoutType == .outdoorRun ? "figure.run": "figure.walk")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
            VStack(alignment: .leading) {
                Text("Outdoor Run")
                    .font(.system(size: 24))
                    .fontDesign(.rounded)
                Text("3.00km")
                    .font(.system(size: 24))
                    .fontDesign(.rounded)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Avg")
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
                + Text(Image(systemName: "heart"))
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
                    .foregroundStyle(.red)
                + Text ("160")
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
                Text("April 26, 2025")
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
            }
        }
    }
}

#Preview {
    VStack {

        List {
            WorkoutCell(workoutType: .outdoorWalk)
        }
    }
}
