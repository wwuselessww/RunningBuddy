import SwiftUI

struct TestView: View {
    @State var viewFrames: [CGRect] = [.zero, .zero, .zero]
    var body: some View {
        VStack {
            HStack {
                Text("From")
                    .track(index: 0)
                Spacer()
            }
            Spacer()
            Text("center")
                .track(index: 1)
            Spacer()
            HStack {
                Spacer()
                Text("hedsre")
                    .track(index: 2)
            }
        }
        
        .onPreferenceChange(UpdateArray.self) { preferences in
                    for pref in preferences {
                        if viewFrames.indices.contains(pref.index) {
                            viewFrames[pref.index] = pref.frame
                        }
                    }
                }
        .onAppear {
            print(viewFrames)
        }
    }
}

#Preview {
    TestView()
}
