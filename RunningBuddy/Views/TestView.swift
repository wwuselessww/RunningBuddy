import SwiftUI

struct TestView: View {
    @State var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @State var isPlaying: Bool = false
    @State var displayTime: Int = 60
    var body: some View {
        VStack {
            Text(timeString(from: displayTime))
                .onReceive(timer) { output in
                    displayTime -= 1
                }
            Button {
                isPlaying.toggle()
                if isPlaying {
                    timer.upstream.connect().cancel()
                } else {
                    timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
                }
            } label: {
                Text("play/pause")
            }

        }
    }
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let newSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, newSeconds)
    }
}

#Preview {
    TestView()
}
