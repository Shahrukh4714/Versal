import SwiftUI

// MARK: - Ink Theme Palette

extension Color {
    static let inkBlue = Color(red: 0x2D / 255, green: 0x4A / 255, blue: 0x8A / 255)
    static let inkMid = Color(red: 0x25 / 255, green: 0x39 / 255, blue: 0x6B / 255)
    static let inkBlack = Color(red: 0x16 / 255, green: 0x21 / 255, blue: 0x3E / 255)
    static let inkSheen = Color(red: 0x6B / 255, green: 0x8C / 255, blue: 0xC4 / 255)
    static let inkWash = Color(red: 0xEE / 255, green: 0xF1 / 255, blue: 0xF7 / 255)

    static let backgroundGrouped = Color(red: 0xF2 / 255, green: 0xF2 / 255, blue: 0xF7 / 255)
    static let surfaceCard = Color.white
    static let darkSurface = Color(red: 0x0B / 255, green: 0x0B / 255, blue: 0x10 / 255)
    static let darkCard = Color(red: 0x1C / 255, green: 0x1C / 255, blue: 0x24 / 255)

    static let labelPrimary = Color(red: 0x1C / 255, green: 0x1C / 255, blue: 0x1E / 255)
    static let labelSecondary = Color(red: 0x8E / 255, green: 0x8E / 255, blue: 0x93 / 255)
    static let labelTertiary = Color(red: 0xAE / 255, green: 0xAE / 255, blue: 0xB2 / 255)
    static let labelQuaternary = Color(red: 0xC7 / 255, green: 0xC7 / 255, blue: 0xCC / 255)

    static let successGreen = Color(red: 0x22 / 255, green: 0xC5 / 255, blue: 0x5E / 255)
    static let warningAmber = Color(red: 0xF5 / 255, green: 0x9E / 255, blue: 0x0B / 255)
    static let destructiveRed = Color(red: 0xEF / 255, green: 0x44 / 255, blue: 0x44 / 255)

    static let aiGradientStart = Color(red: 0x8B / 255, green: 0x5C / 255, blue: 0xF6 / 255)
    static let aiGradientEnd = Color(red: 0x63 / 255, green: 0x66 / 255, blue: 0xF1 / 255)
}

// MARK: - File Type Colors

extension Color {
    static func fileIconColor(for type: FileType) -> Color {
        switch type {
        case .pdf: return Color(red: 0xEF / 255, green: 0x44 / 255, blue: 0x44 / 255)
        case .docx: return Color(red: 0x3B / 255, green: 0x82 / 255, blue: 0xF6 / 255)
        case .jpg: return Color(red: 0xF5 / 255, green: 0x9E / 255, blue: 0x0B / 255)
        case .png: return Color(red: 0x10 / 255, green: 0xB9 / 255, blue: 0x81 / 255)
        case .mp4: return Color(red: 0x8B / 255, green: 0x5C / 255, blue: 0xF6 / 255)
        case .zip: return Color(red: 0x6B / 255, green: 0x72 / 255, blue: 0x80 / 255)
        case .pptx: return Color(red: 0xF9 / 255, green: 0x73 / 255, blue: 0x16 / 255)
        case .xlsx: return Color(red: 0x16 / 255, green: 0xA3 / 255, blue: 0x4A / 255)
        }
    }

    static func fileBackgroundColor(for type: FileType) -> Color {
        switch type {
        case .pdf: return Color(red: 0xFE / 255, green: 0xF2 / 255, blue: 0xF2 / 255)
        case .docx: return Color(red: 0xEF / 255, green: 0xF6 / 255, blue: 0xFF / 255)
        case .jpg: return Color(red: 0xFF / 255, green: 0xFB / 255, blue: 0xEB / 255)
        case .png: return Color(red: 0xEC / 255, green: 0xFD / 255, blue: 0xF5 / 255)
        case .mp4: return Color(red: 0xF5 / 255, green: 0xF3 / 255, blue: 0xFF / 255)
        case .zip: return Color(red: 0xF9 / 255, green: 0xFA / 255, blue: 0xFB / 255)
        case .pptx: return Color(red: 0xFF / 255, green: 0xF7 / 255, blue: 0xED / 255)
        case .xlsx: return Color(red: 0xF0 / 255, green: 0xFD / 255, blue: 0xF4 / 255)
        }
    }
}
