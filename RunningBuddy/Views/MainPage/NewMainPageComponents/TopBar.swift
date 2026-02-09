//
//  TopBar.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.01.26.
//

import SwiftUI

struct WeekHeader: View {
    @Binding var waterLevel: Double
    @Binding var waterTitle: Int
    @Binding var days: [Days]
    @Binding var chosenDay: Int
    @Binding var activityValue: Double
    @Binding var activityTitle: Int
    
    
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    WaterBalance(waterBalance: $waterLevel, title: $waterTitle)
                        .frame(width: 55)
                    ForEach($days, id: \.id) { day in
                        Spacer()
                        DayCard(day: day, isChosen: $chosenDay)
                        
                    }
                    ActivityRing(value: $activityValue, title: $activityTitle)
                        .frame(width: 55)
                    Spacer()
                }
            }
            .zIndex(1)
            .padding(.horizontal)
            .glassEffect(in: .rect(cornerRadius: 50))
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60, maxHeight: 140)
        } else {
            // Fallback on earlier versions
            Text("NO IMPLEMENTATION")
        }
    }
}

//#Preview {
//    WeekHeader()
//}
