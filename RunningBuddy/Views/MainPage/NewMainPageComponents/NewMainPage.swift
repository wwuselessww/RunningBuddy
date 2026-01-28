//
//  NewMainPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 27.01.26.
//

import SwiftUI

struct NewMainPage: View {
    @State var days: [Days] = [.init(name: "mon", number: 26),.init(name: "tue", number: 27),.init(name: "wen", number: 28),.init(name: "thu", number: 29),.init(name: "fri", number: 30),.init(name: "sat", number: 31),.init(name: "sun", number: 1)]
    @State var activityValue = 0.1
    @State var waterLevel = 0.7
    @State var isPressed : Bool = false
    @State var chosenDay: String = ""
    @State var waterTitle: Int = 10
    @State var activityTitle: Int = 15
    
    
    @ObservedObject var vm = MainPageViewModel()
    @State var authenticated: Bool = false
    @State var trigger: Bool = false
    @State private var path = NavigationPath()
    
    
    var body: some View {
            VStack {
                WeekHeader(waterLevel: $waterLevel, waterTitle: $waterTitle, days: $days, chosenDay: $chosenDay, activityValue: $activityValue, activityTitle: $activityTitle)
                ScrollView {
                    ForEach(0..<2) { i in
                        NewActivityCell()
                            .padding(.all)
                            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 500, maxHeight: 500)
                    }
                }.scrollClipDisabled()
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
    }
}


struct Days: Identifiable {
   let id: UUID = UUID()
    var name: String
    var number: Int
    var isSelected: Bool = false
}

#Preview {
    NewMainPage()
}
