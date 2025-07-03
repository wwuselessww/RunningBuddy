//
//  TrainingDetail.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

struct TrainingDetail<Content: View>: View {
    var title: String
//    @Binding var metric: String
    var unitOfMeasurement: String
    var isTime: Bool = false
    var content: Content
    
    init(title: String, unitOfMeasurement: String, isTime: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.unitOfMeasurement = unitOfMeasurement
        self.content = content()
        self.isTime = isTime
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 24))
                .foregroundStyle(.blue)
            HStack {
                content
                    .contentTransition(.numericText())
                //FIXME: MUST BE REWORKED
                    .frame(alignment: .leading)

                Text("\(unitOfMeasurement)")
                    
            }
                .font(.system(size: 36))
        }
        .fontWeight(.semibold)
    }
}

#Preview {
    @Previewable @State var speed: Int = 10
    var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    VStack {
        Spacer(minLength: 600)
        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
            GridRow {
                Spacer()
                TrainingDetail(title: "Speed", unitOfMeasurement: "km/h", isTime: true) {
                    Text("\(Double(speed).timeString())")
                }
                .gridCellAnchor(.leading)
                TrainingDetail(title: "Speed", unitOfMeasurement: "km/h", isTime: false) {
                    Text("\(speed)")
                }
                Spacer()
            }
            GridRow {
                Spacer()
                TrainingDetail(title: "Speed", unitOfMeasurement: "km/h", isTime: false) {
                    Text("\(speed)")
                }
                TrainingDetail(title: "Speed", unitOfMeasurement: "km/h", isTime: false) {
                    Text("\(speed)")
                }
                Spacer()
            }
            Spacer()
        }
        .frame(minWidth: 100, maxWidth: .infinity)
        .background(content: {
            Color.red.ignoresSafeArea()
        })
        
    }
        
    
        .onReceive(timer) { new in
            print("kek")
            speed = Int.random(in: 0...100)
        }
}

