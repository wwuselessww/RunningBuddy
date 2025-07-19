//
//  ProgressGraph.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 14.07.25.
//

import SwiftUI
import Charts

struct TestView: View {
    var title: String
    var progress: Int
   @State var data: [ChartModel] = [
//        .init(index: 0, number: 12),
//        .init(index: 1, number: 122),
//        .init(index: 2, number: 1),
//        .init(index: 3, number: 200),
//        .init(index: 4, number: 322),
//        .init(index: 5, number: 82),
        
    ]
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(.body, design: .rounded))
                Text(progress.description)
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                    .contentTransition(.numericText() )
                buildChart()
               
                
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            }
            .frame(width: 182, height: 182)
            Button {
                randomizeData()
            } label: {
                Text("Randomze data")
            }
        }
    }
     func randomizeData() {
        for index in data.indices {
            let randomValue = Int.random(in: 0...300)
            data[index].number = randomValue
        }
    }
    @ViewBuilder
    func buildChart() -> some View {
        Chart {
            ForEach(data) { unit in
                LineMark(x: .value("day", unit.date),
                        y: .value("Steps", unit.number)
                )
            }
        }
        .animation(.snappy, value: data)
        .chartYScale(domain: 0...400)
    }
    
   
}


#Preview {
    TestView(title: "Step Count", progress: 2000)
}
