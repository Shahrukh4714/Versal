import Foundation

protocol OCRServiceProtocol {
    func recognizeText(in imageData: Data) async throws -> String
    func searchInFiles(query: String) async throws -> [FileItem]
}
