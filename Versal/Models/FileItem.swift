import Foundation

struct FileItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let fileType: FileType
    let fileSize: Int64
    let createdAt: Date
    let modifiedAt: Date
    let isLocked: Bool
    let isProFeature: Bool
    let url: URL

    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }

    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}
