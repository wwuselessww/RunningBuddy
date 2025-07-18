//
//  ProgressGraph.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 14.07.25.
//

import SwiftUI
import Charts

struct ProgressGraph: View {
    var title: String
    @Binding var progress: Int
    @Binding var dateRange: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(.body, design: .rounded))
            Text(progress.description)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
            Chart {
                ForEach(0..<dateRange, id: \.self) { num in
                    LineMark(x: .value("day", num), y: .value("distance", Int.random(in: 0...10)))
                }
                .interpolationMethod(.cardinal)
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(radius: 4)
        }
        .frame(width: 182, height: 182)
    }
}


#Preview {
    ProgressGraph(title: "Step Count", progress: .constant(2000), dateRange: .constant(31))
}
