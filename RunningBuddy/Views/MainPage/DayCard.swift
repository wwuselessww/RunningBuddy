//
//  DayCard.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 27.01.26.
//

import SwiftUI

struct DayCard: View {
    @Binding var day: Days
    @Binding var isChosen: Int
    var body: some View {
        Button {
            withAnimation {
                isChosen = day.number
            }
            print(isChosen)
        } label: {
            VStack {
                Text(day.name.capitalized)
                Text(day.number.description)
            }
            .foregroundStyle(Color(.label))
            .font(.caption.bold())
            .frame(width: 30, height: 50)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle( isChosen == day.number ? .gray.opacity(0.1) : .clear)
            }
        }


    }
}
