//
//  Face.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 16.03.26.
//

import SwiftUI


struct Face: View {
    @Binding var emotion: Emotion?
    @State var color: Color
    
    @State private var radius: Double = 200
    @State private var height: Double = 100
    @State private var width: Double = 100
    
    @State private var mouthRotation: Double = 0
    @State private var eyeRotation: Double = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: radius)
                            .frame(width: width)
                            .rotationEffect(.degrees(-eyeRotation))
                        Spacer()
                        RoundedRectangle(cornerRadius: radius)
                            .frame(width: width)
                            .rotationEffect(.degrees(eyeRotation))
                        Spacer()
                    }
                    .frame(height: height)
                    .foregroundStyle(color)
                BeanMouth()
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: 28,
                            lineCap: .round
                        )
                    )
                    .frame(width: 120, height: 60)
                    .rotationEffect(.degrees(mouthRotation))
                    .padding(.vertical)
                Spacer()
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        print("changed")
                        emotion = .easy
                    }
                }
            })
            .padding()
            .onChange(of: emotion) { _, newValue in
                let actualWidth = geo.size.width / 2.5
                let actualHeight = geo.size.width / 2
                withAnimation {
                    switch newValue {
                    case .easy:
                        height = actualHeight / 2
                        width = actualWidth / 1.5
                        radius  = height
                        mouthRotation = 0
                        eyeRotation = 0
                        
                    case .mid:
                        height = actualHeight / 1.5
                        width = height
                        radius  = height
                        mouthRotation = 180
                        eyeRotation = 0
                        
                    case .hard:
                        radius = 50
                        height = actualHeight / 2.5
                        width = actualWidth / 3
                        mouthRotation = 180
                        eyeRotation = 45
                    default:
                        print("NILL")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var emotion: Emotion? = .mid
    @Previewable @State var stage: Int = 0
    VStack {
        Text(emotion?.rawValue ?? "emotion is nill")
        Spacer()
        Face(emotion: $emotion, color: .blue)
        Spacer()
        Picker("Emotion", selection: $emotion) {
            Text("Easy").tag(Emotion.easy)
            Text("Mid").tag(Emotion.mid)
            Text("Hard").tag(Emotion.hard)
        }
        .pickerStyle(.segmented)
        .padding()
    }
}



