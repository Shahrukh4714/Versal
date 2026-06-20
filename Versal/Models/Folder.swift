import Foundation

struct Folder: Identifiable, Codable {
    let id: UUID
    let name: String
    let fileCount: Int
    let colorHex: String
}
