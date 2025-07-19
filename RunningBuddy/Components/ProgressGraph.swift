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
    var progress: Int
    var barColor: Color = .blue
    var interval: ProgressPickerOption
   @Binding var data: [ChartModel]
    @State private var rawSelectedDate: Date?
   private var selectedInterval: Calendar.Component {
        switch interval {
        case .day:
            return .hour
        case .year:
            return .month
        default:
            return .day
        }
    }
    var selectedChartData: ChartModel? {
        guard let rawSelectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: selectedInterval)
        }
    }
    
    private var dateFormat: Date.FormatStyle {
        switch interval {
        case .day:
            return .dateTime.hour(.conversationalDefaultDigits(amPM: .wide))
        case .year:
            return .dateTime.month(.wide)
        default:
            return .init(date: .abbreviated, time: .omitted)
        }
    }
    
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
            .frame(height: 182)
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
            
            if let selectedChartData = selectedChartData {
                RuleMark(x: .value("selected date", selectedChartData.date, unit: selectedInterval))
                    .foregroundStyle(.secondary.opacity(0.3))
                    .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        VStack {
                            Text(selectedChartData.date, format: dateFormat)
                                .bold()
                            Text("\(selectedChartData.number) steps")
                                .font(.title3)
                                .bold()
                            
                        }
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(width: 120)
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(barColor.gradient)
                        }
                    }
            }
            
            ForEach(data) { unit in
                BarMark(x: .value("day", unit.date),
                        y: .value("Steps", unit.number),
                        width: .automatic
                )
                .opacity(rawSelectedDate == nil || unit.date == selectedChartData?.date ? 1 : 0.3)
                .foregroundStyle(barColor)
                
            }
        }
        .animation(.snappy, value: data)
        .chartYScale(domain: 0...(data.max(by: { $0.number < $1.number })?.number ?? 0))
        .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
        .onChange(of: selectedChartData?.number) { oldValue, newValue in
            print(newValue)
        }
    }
    
   
}


#Preview {
    @Previewable @State var data: [ChartModel] = [
        ChartModel(date: Date.now, number: 10),
        ChartModel(date: Date.now.addingTimeInterval(1), number: 9),
        ChartModel(date: Date.now.addingTimeInterval(2), number: 2),
        ChartModel(date: Date.now.addingTimeInterval(3), number: 9),
     ]
    ProgressGraph(title: "Step Count", progress: 2000, barColor: .red, interval: .day, data: $data)
}
