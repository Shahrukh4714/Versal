import SwiftUI

struct IconChevronRight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY - rect.height * 0.15))
        return path
    }
}

struct IconChevronDown: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.minY + rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.25))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.minY + rect.height * 0.25))
        return path
    }
}

struct IconClose: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.maxY - rect.height * 0.15))
        path.move(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.maxY - rect.height * 0.15))
        return path
    }
}

struct IconPlus: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.15))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.midY))
        return path
    }
}

struct IconCheckmark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.midY + rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.05, y: rect.maxY - rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.minY + rect.height * 0.2))
        return path
    }
}

struct IconInfo: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.3), radius: rect.width * 0.06, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.1))
        return path
    }
}

struct IconArrowUp: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.12))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.35))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.minY + rect.height * 0.35))
        return path
    }
}

struct IconDownload: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.35))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.maxY - rect.height * 0.55))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.25, y: rect.maxY - rect.height * 0.55))
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.12, y: rect.maxY - rect.height * 0.2, width: rect.width * 0.76, height: rect.height * 0.12), cornerSize: CGSize(width: 3, height: 3))
        return path
    }
}
