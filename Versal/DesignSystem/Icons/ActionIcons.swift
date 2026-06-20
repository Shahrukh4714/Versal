import SwiftUI

struct IconSearch: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.35), radius: rect.width * 0.22, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.5, y: rect.minY + rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.maxY - rect.height * 0.12))
        return path
    }
}

struct IconTrash: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.minY + rect.height * 0.25))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.35))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.32, y: rect.maxY - rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.32, y: rect.maxY - rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.3, y: rect.minY + rect.height * 0.35))
        return path
    }
}

struct IconShare: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.55))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.minY + rect.height * 0.35))
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.12, y: rect.minY + rect.height * 0.55, width: rect.width * 0.76, height: rect.height * 0.37), cornerSize: CGSize(width: 4, height: 4))
        return path
    }
}

struct IconFolder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.maxY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.maxY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.15, y: rect.minY + rect.height * 0.12))
        path.closeSubpath()
        return path
    }
}

struct IconLock: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.15, y: rect.minY + rect.height * 0.42, width: rect.width * 0.7, height: rect.height * 0.5), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.42))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.25))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.25), radius: rect.width * 0.17, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.35, y: rect.minY + rect.height * 0.42))
        return path
    }
}

struct IconMerge: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.maxY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.minY + rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.minY + rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.maxY - rect.height * 0.08))
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.08))
        return path
    }
}

struct IconDocument: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.05, width: rect.width * 0.84, height: rect.height * 0.9), cornerSize: CGSize(width: 4, height: 4))
        let lineY: [CGFloat] = [0.35, 0.5, 0.65]
        for y in lineY {
            path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * y))
            path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * y))
        }
        return path
    }
}
