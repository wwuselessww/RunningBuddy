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
            VStack {
                Spacer(minLength: 50)
                HStack {
                    Circle()
                        .foregroundStyle(.clear)
                        .frame(width: 60)
                    ForEach($days, id: \.id) { day in
                        Spacer()
                        DayCard(day: day, isChosen: $chosenDay)
                    }
                    ActivityRing(value: $activityValue, title: $activityTitle)
                        .frame(width: 65)
                        .padding(.bottom)
                        .padding(.trailing)
                    Spacer()
                }
            }
            .zIndex(1)
            .padding(.horizontal)
            .glassEffect(in: .rect(cornerRadius: 50))
            .ignoresSafeArea(edges: .top)
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60, maxHeight: 120)
            
        }
    }

#Preview {
    @Previewable @State var viewModel = MainPageViewModel()
    VStack {
        WeekHeader(waterLevel: $viewModel.waterLevel, waterTitle: $viewModel.waterTitle, days: $viewModel.days, chosenDay: $viewModel.chosenDay, activityValue: $viewModel.activityValue, activityTitle: $viewModel.activityTitle)
        Spacer()
    }
    
}
