import SwiftUI

struct Logomark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: w * 0.25, y: h * 0.05))
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.35, y: h * 0.55))

        path.move(to: CGPoint(x: w * 0.75, y: h * 0.05))
        path.addLine(to: CGPoint(x: w * 0.95, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.55))

        return path
    }
}

struct LogomarkContainer: View {
    var size: CGFloat = IconSize.logomark

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(LinearGradient(
                    colors: [.inkBlack, .inkBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: size, height: size)

            Logomark()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
                .frame(width: size * 0.6, height: size * 0.7)
        }
    }
}

struct LogomarkHero: View {
    var body: some View {
        Logomark()
            .stroke(Color.inkBlue.opacity(0.1), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: IconSize.logomarkHero, height: IconSize.logomarkHero)
    }
}

struct LogomarkInline: View {
    var body: some View {
        Logomark()
            .stroke(Color.inkBlue, style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round))
            .frame(width: IconSize.logomarkSmall, height: IconSize.logomarkSmall)
    }
}
