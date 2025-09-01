//
//  ActivityBar.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct ActivityBar: View {
    let colorArray: [Color] = [
        .init(hex: 0xD0EBC2),
        .init(hex: 0xC1E8AD),
        .init(hex: 0xB1E597),
        .init(hex: 0x9EE979),
        .init(hex: 0xE9DA79),
        .init(hex: 0xE9AD79),
        .init(hex: 0xE97979)
    ]
    
    var activityToDraw: Int {
        let temp = Float(colorArray.count)/Float(maxActivity)*Float(closedActivity)
        
        let res = temp.rounded(.toNearestOrAwayFromZero)
        return Int(res)
    }
    
    @Binding var maxActivity: Int
    @Binding var closedActivity: Int
    var title: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.system(size: 24))
                .fontDesign(.rounded)
            HStack( spacing: 7) {
                ForEach(0..<colorArray.count, id: \.self) { index in
                    if index < activityToDraw {
                        RoundedRectangle(cornerRadius: 5, )
                            .foregroundStyle(colorArray[index])
                            .frame(minWidth: 35, maxWidth: 90, minHeight: 26, maxHeight: 30)
                    } else {
                        RoundedRectangle(cornerRadius: 5, )
                            .foregroundStyle(.gray)
                            .frame(minWidth: 35, maxWidth: 90, minHeight: 26, maxHeight: 30)
                    }
                }
            }
        }
        .frame(minWidth: 200, maxWidth: .infinity)
        
    }
}

#Preview {
    @Previewable @State var currentActivity: Int = 0
    ActivityBar(maxActivity: .constant(1000), closedActivity: $currentActivity, title: "Activity")
    
    Button {
        currentActivity += 100
    } label: {
        Text("add")
        Text("\(currentActivity)")
    }
}

