//
//  Face.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 16.03.26.
//

import SwiftUI


struct Face: View {
    @Binding var emotion: Emotion
    
    @State private var radius: Double = 200
    @State private var height: Double = 200
    @State private var width: Double = 200
    
    @State private var mouthRotation: Double = 0
    @State private var eyeRotation: Double = 0
    var body: some View {
        VStack {
                HStack {
                    RoundedRectangle(cornerRadius: radius)
                        .frame(width: width)
                        .rotationEffect(.degrees(-eyeRotation))
                    Spacer()
                    RoundedRectangle(cornerRadius: radius)
                        .frame(width: width)
                        .rotationEffect(.degrees(eyeRotation))
                        
                }
                .frame(height: height)
            
            BeanMouth()
                .stroke(
                    Color.black,
                    style: StrokeStyle(
                        lineWidth: 28,
                        lineCap: .round
                    )
                )
                .frame(width: 120, height: 60)
                .rotationEffect(.degrees(mouthRotation))
                .padding(.vertical)
        }
        .padding()
        .onChange(of: emotion) { _, newValue in
            withAnimation {
                switch newValue {
                case .easy:
                    height = 180
                    width = 180
                    radius  = height
                    mouthRotation = 0
                    eyeRotation = 0
                    
                case .mid:
                    height = 130
                    width = 180
                    radius  = height
                    mouthRotation = 180
                    eyeRotation = 0
                    
                case .hard:
                    radius = 50
                    height = 50
                    width = 150
                    mouthRotation = 180
                    eyeRotation = 0
                    
                default:
                    print("default")
                }
                
            }
        }
    }
}

#Preview {
    @Previewable @State var emotion: Emotion = .hard
    @Previewable @State var stage: Int = 0
    VStack {
        Text(emotion.rawValue)
        Spacer()
        Face(emotion: $emotion)
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


enum Emotion: String {
    case easy = "easy"
    case mid = "mid"
    case hard = "hard"
}
