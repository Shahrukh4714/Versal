import Foundation

enum ActivityEventType: Codable {
    case fileScanned(filename: String)
    case fileConverted(filename: String, targetFormat: String)
    case fileMerged(fileCount: Int)
    case faceIDEnabled
    case cameraAccessed
    case appLocked
    case fileExported(filename: String)
}

struct ActivityEvent: Identifiable, Codable {
    let id: UUID
    let type: ActivityEventType
    let timestamp: Date
    let isSystemEvent: Bool

    var description: String {
        switch type {
        case .fileScanned(let name): return "Scanned"
        case .fileConverted(let name, let format): return "Converted to \(format)"
        case .fileMerged(let count): return "Merged · \(count) files"
        case .faceIDEnabled: return "Enabled for app lock"
        case .cameraAccessed: return "Accessed for scanning"
        case .appLocked: return "App locked"
        case .fileExported(let name): return "Exported"
        }
    }

    var relativeTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
