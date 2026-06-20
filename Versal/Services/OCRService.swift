import Foundation
import Vision
import UIKit

final class OCRService: OCRServiceProtocol {
    func recognizeText(in imageData: Data) async throws -> String {
        guard let image = UIImage(data: imageData),
              let cgImage = image.cgImage else { throw OCRError.invalidImage }

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        guard let observations = request.results else { return "" }

        return observations.compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: " ")
    }

    func searchInFiles(query: String) async throws -> [FileItem] {
        let fileService = FileService()
        let files = try await fileService.listFiles()
        let filtered = files.filter { $0.name.localizedCaseInsensitiveContains(query) }

        // OCR search would scan document images for text matches
        // For V1, search by filename only
        return filtered
    }
}

enum OCRError: Error, LocalizedError {
    case invalidImage
    var errorDescription: String? { "Could not process image for text recognition" }
}
