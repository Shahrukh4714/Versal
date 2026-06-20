import SwiftUI

struct ProgressRing: View {
    let progress: Double
    var lineWidth: CGFloat = 8
    var color: Color = .inkBlue

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.inkWash, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}
