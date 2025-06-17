//
//  HoldToSkipButton.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 13.06.25.
//

import SwiftUI

struct HoldToSkipButton: View {
    @State var isHolded = false
    let onHold: () -> Void
    let onHoldEnded:() -> Void
    var body: some View {
        //        Button {
        //
        //        } label: {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(isHolded ? .red : .blue)
            Text("Hold To Skip")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(minWidth: 40, maxWidth: 140, minHeight: 100, maxHeight: 110)
        .sensoryFeedback(.success, trigger: isHolded)
        //        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onChanged({ _ in
                isHolded = true
                onHold()
            }).onEnded({ _ in
                isHolded = false
                onHoldEnded()
            })
        )
    }
}
#Preview {
    HoldToSkipButton {
        print("Holded")
    } onHoldEnded: {
        print("holdEnded")
    }

}
