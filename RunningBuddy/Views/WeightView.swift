//
//  WeughtView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.04.26.
//

import SwiftUI

struct WeightView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedWeight: Int
    @State var units: WeightUnits = .kg
    @State private var isButtonEnable: Bool = false
    private let weightsArray: [Int] = Array(0..<200)
    var needsDismiss: Bool = false
    
    init(selectedWeight: Binding<Int>, needsDismiss: Bool = false) {
        self._selectedWeight = selectedWeight
        self.needsDismiss = needsDismiss
    }
    
    var body: some View {
        VStack {
            Text("What is your current weight?")
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
                .fontDesign(.rounded)
                .padding()
                .glassEffect(.regular.tint(.gray))
            Spacer()
            HStack {
                Picker("Weight", selection: $selectedWeight) {
                    ForEach(weightsArray, id: \.self) { unit in
                        Text(unit.description)
                            .font(.largeTitle)
                            .bold()
                            .fontDesign(.rounded)
                    }
                }
                Picker("Weight Units", selection: $units) {
                    ForEach(WeightUnits.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                            .font(.largeTitle)
                            .bold()
                            .fontDesign(.rounded)
                    }
                }
                
            }
            .pickerStyle(.wheel)
            .font(.title)
            .padding(.horizontal)
            Spacer()
            Button {
                saveWeight()
                if needsDismiss {
                    dismiss()
                }
            } label: {
                Text("Confirm")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                    .fontDesign(.rounded)
                    .padding(.all)
                    
            }
            .glassEffect(.regular.interactive().tint(isButtonEnable ? .blue : .gray))
            .disabled(!isButtonEnable)
            .padding(.bottom, 100)
//            Spacer()
        }
        
        .onChange(of: selectedWeight) { _, _ in
            isButtonEnable = true
        }
    }
    
    func saveWeight() {
        UserProvider.shared.saveWeight(selectedWeight)
    }
    
}

#Preview {
    WeightView(selectedWeight: .constant(20))
}

enum WeightUnits: String, CaseIterable {
    case kg = "kg"
    case pound = "lbs"
}
