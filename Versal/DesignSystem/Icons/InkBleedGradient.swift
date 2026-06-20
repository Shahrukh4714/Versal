import SwiftUI

struct InkBleedGradient: View {
    var body: some View {
        RadialGradient(
            colors: [.inkSheen, .inkBlue, .inkBlack],
            center: UnitPoint(x: 0.8, y: 0.08),
            startRadius: 0,
            endRadius: 400
        )
    }
}

struct GrainOverlay: View {
    var body: some View {
        Canvas { context, size in
            for x in stride(from: 0, to: Int(size.width), by: 3) {
                for y in stride(from: 0, to: Int(size.height), by: 3) {
                    let opacity = Float.random(in: 0...0.5)
                    context.fill(
                        Path(CGRect(x: x, y: y, width: 1, height: 1)),
                        with: .color(.black.opacity(Double(opacity)))
                    )
                }
            }
        }
        .blendMode(.overlay)
        .opacity(0.5)
        .allowsHitTesting(false)
    }
}
