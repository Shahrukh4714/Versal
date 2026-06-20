import SwiftUI

struct IconHome: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.minY + rect.height * 0.42))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.maxY - rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.maxY - rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.minY + rect.height * 0.42))
        path.closeSubpath()
        return path
    }
}

struct IconFiles: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY - rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.maxY - rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.38, y: rect.minY + rect.height * 0.1))
        path.closeSubpath()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.38, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.38, y: rect.minY + rect.height * 0.1))
        return path
    }
}

struct IconConvert: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.midY), radius: rect.width * 0.18, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.addArc(center: CGPoint(x: rect.maxX - rect.width * 0.3, y: rect.midY), radius: rect.width * 0.18, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.3 + rect.width * 0.18, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.3 - rect.width * 0.18, y: rect.midY))
        return path
    }
}

struct IconScanner: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.2, width: rect.width * 0.84, height: rect.height * 0.6), cornerSize: CGSize(width: 6, height: 6))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.2))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.midY))
        return path
    }
}

struct IconSettings: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width * 0.16, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        for angle in stride(from: 0, to: 360, by: 45) {
            let rad = angle * .pi / 180
            let inner = CGPoint(x: rect.midX + cos(rad) * rect.width * 0.22, y: rect.midY + sin(rad) * rect.width * 0.22)
            let outer = CGPoint(x: rect.midX + cos(rad) * rect.width * 0.35, y: rect.midY + sin(rad) * rect.width * 0.35)
            path.move(to: inner)
            path.addLine(to: outer)
        }
        return path
    }
}
