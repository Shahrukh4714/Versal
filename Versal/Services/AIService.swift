import Foundation
import PDFKit
import Speech
import AVFoundation
import CoreImage
import UIKit

final class AIService: AIServiceProtocol {
    func chatWithPDF(documentURL: URL, question: String) async throws -> String {
        guard let doc = PDFDocument(url: documentURL) else { throw AIError.invalidDocument }
        var fullText = ""
        for i in 0..<doc.pageCount {
            guard let page = doc.page(at: i),
                  let text = page.string else { continue }
            fullText += text + "\n"
        }
        // Simple keyword-based response for V1
        // Full LLM integration would use CoreML
        if fullText.isEmpty {
            return "No text content found in this document."
        }
        if fullText.localizedCaseInsensitiveContains(question) {
            return "Yes, I found references to '\(question)' in the document."
        }
        return "Based on the document, I found \(fullText.split(separator: " ").count) words across \(doc.pageCount) pages."
    }

    func summarize(documentURL: URL) async throws -> String {
        guard let doc = PDFDocument(url: documentURL) else { throw AIError.invalidDocument }
        var fullText = ""
        for i in 0..<doc.pageCount {
            guard let page = doc.page(at: i),
                  let text = page.string else { continue }
            fullText += text + "\n"
        }
        let words = fullText.split(separator: " ")
        if words.isEmpty { return "No text content found." }
        let first100 = words.prefix(100).joined(separator: " ")
        return "Summary: \(first100)... [\(doc.pageCount) pages, \(words.count) words]"
    }

    func translate(text: String, to language: String) async throws -> String {
        // V1: returns original text
        // Full translation requires CoreML model
        return "[\(language) translation]\n\(text)"
    }

    func transcribeAudio(at url: URL) async throws -> String {
        let recognizer = SFSpeechRecognizer()
        guard let recognizer = recognizer, recognizer.isAvailable else {
            throw AIError.speechNotAvailable
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false

        return try await withCheckedThrowingContinuation { continuation in
            recognizer.recognitionTask(with: request) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                if let result = result, result.isFinal {
                    continuation.resume(returning: result.bestTranscription.formattedString)
                }
            }
        }
    }

    func enhancePhoto(at url: URL) async throws -> URL {
        guard let image = UIImage(contentsOfFile: url.path),
              let ciImage = CIImage(image: image) else { throw AIError.invalidImage }

        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(1.1, forKey: kCIInputContrastKey)
        filter?.setValue(1.05, forKey: kCIInputBrightnessKey)
        filter?.setValue(1.0, forKey: kCIInputSaturationKey)

        guard let output = filter?.outputImage,
              let cgImage = CIContext().createCGImage(output, from: output.extent) else {
            throw AIError.enhanceFailed
        }

        let enhanced = UIImage(cgImage: cgImage)
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDir.appendingPathComponent("Enhanced-\(url.lastPathComponent)")

        guard let data = enhanced.jpegData(compressionQuality: 0.95) else {
            throw AIError.enhanceFailed
        }
        try data.write(to: outputURL)
        return outputURL
    }
}

enum AIError: Error, LocalizedError {
    case invalidDocument
    case speechNotAvailable
    case invalidImage
    case enhanceFailed

    var errorDescription: String? {
        switch self {
        case .invalidDocument: return "Could not read document"
        case .speechNotAvailable: return "Speech recognition is not available on this device"
        case .invalidImage: return "Could not process image"
        case .enhanceFailed: return "Image enhancement failed"
        }
    }
}
