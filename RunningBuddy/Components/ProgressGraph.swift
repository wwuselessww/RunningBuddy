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
   /* @Binding*/ var progress: Int
    /*@Binding */var data: [Double]
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(.body, design: .rounded))
            Text(progress.description)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
                .contentTransition(.numericText() )
            Chart {
                ForEach(Array(data.enumerated()), id: \.offset) { index, num in
                    LineMark(x: .value("day", index), y: .value("distance",num))
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
    ProgressGraph(title: "Step Count", progress: 2000, data: [])
}
