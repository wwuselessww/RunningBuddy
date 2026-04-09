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
    
    let timeArray: [Int]
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("This much of walking")
                    .font(.default)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .foregroundStyle(.label)
                    .padding(.vertical,5)
                    .padding(.horizontal, 10)
                    .glassEffect(.regular)
                Spacer()
            }
            .padding(.bottom, 10)
            Picker("Time", selection: $selectedTime) {
                ForEach(timeArray, id: \.self) { time in
                    Text("\(time)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        
                }
            }
            .pickerStyle(.wheel)
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
        WalkDurationPicker(selectedTime: .constant(285), height: 300, timeArray: []) {
            
        }
        Spacer()
    }
    .background {
        Color.red
            .ignoresSafeArea()
    }
}
