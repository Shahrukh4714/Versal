import SwiftUI

struct IconPDF: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.05, width: rect.width * 0.84, height: rect.height * 0.9), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.25))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.55))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.55))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.5, y: rect.minY + rect.height * 0.7))
        return path
    }
}

struct IconDOCX: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.05, width: rect.width * 0.84, height: rect.height * 0.9), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.3))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.5))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.7))
        return path
    }
}

struct IconImage: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.08, width: rect.width * 0.84, height: rect.height * 0.84), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.maxY - rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.maxY - rect.height * 0.2))
        path.addArc(center: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.3), radius: rect.width * 0.08, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        return path
    }
}

struct IconVideo: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.15, width: rect.width * 0.6, height: rect.height * 0.7), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.65, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.65, y: rect.maxY - rect.height * 0.25))
        path.closeSubpath()
        return path
    }
}

struct IconArchive: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.12, width: rect.width * 0.84, height: rect.height * 0.76), cornerSize: CGSize(width: 4, height: 4))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.minY + rect.height * 0.35))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.55))
        return path
    }
}
