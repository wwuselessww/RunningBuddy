//
//  WalkDurationPicker.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 23.03.26.
//

import SwiftUI

struct WalkDurationPicker: View {
    @Binding var selectedTime: Int
    
    var height: Int
    
    let timeArray: [Int] = Array(stride(from: 5, to: 305, by: 5))
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("This much of walking")
                
                Spacer()
            }
            .padding(.leading, 30)
            Picker("Time", selection: $selectedTime) {
                ForEach(timeArray, id: \.self) { time in
                    Text("\(time)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        
                }
            }
            .pickerStyle(.wheel)
//            .roundedRectangleWithBorder()
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 3)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                }
            }
            Spacer()
            Button {
                action()
            } label: {
                HStack {
                    Spacer()
                    Text("Start")
                        .font(.title)
                        .foregroundStyle(.white)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(.vertical)
                    .foregroundStyle(.background)
                    .glassEffect(.regular.tint(.blue).interactive())
                
            }

        }
        
    }
}

#Preview {
    VStack {
        Spacer()
        WalkDurationPicker(selectedTime: .constant(285), height: 300) {
            
        }
        Spacer()
    }
    .background {
        Color.black
            .ignoresSafeArea()
    }
}
