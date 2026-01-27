//
//  NewMainPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 27.01.26.
//

import SwiftUI

struct NewMainPage: View {
    @State var days: [Days] = [.init(name: "mon", number: 26),.init(name: "tue", number: 27),.init(name: "wen", number: 28),.init(name: "thu", number: 29),.init(name: "fri", number: 30),.init(name: "sat", number: 31),.init(name: "sun", number: 1)]
    @State var value = 0.1
    @State var chosenDay: String = ""
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        WaterBalance()
                            .frame(width: 50)
                        ForEach($days, id: \.id) { day in
                            Spacer()
                            DayCard(day: day, isChosen: $chosenDay)
                                
                        }
                        ActivityRing(value: $value)
                        Spacer()
                    }
                    .padding()
                }
                .glassEffect(in: .rect(cornerRadius: 50))
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60, maxHeight: 140)
                .ignoresSafeArea()
                Spacer()
                Button("press me") {
                    withAnimation {
                        value = 1
                    }
                }
            }
            
        } else {
            VStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60, maxHeight: 125)
             
                    .ignoresSafeArea()
                
                
                Spacer()
            }
        }
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
