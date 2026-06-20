import SwiftUI

struct IconSign: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.maxY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.maxY - rect.height * 0.08))
        path.addCurve(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.15),
                      control1: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.6),
                      control2: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.1))
        return path
    }
}

struct IconMarkup: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY - rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.maxY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.minY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY - rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY - rect.height * 0.1))
        return path
    }
}

struct IconRedact: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.1, y: rect.minY + rect.height * 0.15, width: rect.width * 0.54, height: rect.height * 0.7), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.minY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.18, y: rect.minY + rect.height * 0.17))
        return path
    }
}

struct IconPages: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.05, y: rect.minY + rect.height * 0.05, width: rect.width * 0.6, height: rect.height * 0.9), cornerSize: CGSize(width: 3, height: 3))
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.1, width: rect.width * 0.6, height: rect.height * 0.85), cornerSize: CGSize(width: 3, height: 3))
        return path
    }
}

struct IconAI: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.4, y: rect.midY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.4, y: rect.midY - rect.height * 0.08))
        path.closeSubpath()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.maxY - rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.35, y: rect.maxY - rect.height * 0.15))
        path.closeSubpath()
        return path
    }
}
