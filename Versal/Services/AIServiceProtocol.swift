import Foundation

protocol AIServiceProtocol {
    func chatWithPDF(documentURL: URL, question: String) async throws -> String
    func summarize(documentURL: URL) async throws -> String
    func translate(text: String, to language: String) async throws -> String
    func transcribeAudio(at url: URL) async throws -> String
    func enhancePhoto(at url: URL) async throws -> URL
}
