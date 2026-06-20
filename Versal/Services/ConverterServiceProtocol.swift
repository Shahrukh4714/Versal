import Foundation

enum ConversionCategory: String, CaseIterable {
    case documents = "Documents"
    case images = "Images"
    case audio = "Audio"
    case video = "Video"
    case archives = "Archives"
    case ebooks = "eBooks"
}

struct ConversionFormat: Identifiable {
    let id = UUID()
    let name: String
    let `extension`: String
    let category: ConversionCategory
    let isRecommended: Bool
}

protocol ConverterServiceProtocol {
    func getAvailableConversions(for sourceType: FileType) -> [ConversionCategory]
    func getRecommendedFormats(for sourceType: FileType) -> [ConversionFormat]
    func convertFile(at url: URL, to format: ConversionFormat) async throws -> FileItem
    func getFormatCount() -> Int
}
