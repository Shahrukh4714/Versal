import Foundation
import UIKit
import PDFKit

final class ConverterService: ConverterServiceProtocol {
    private let fileService = FileService()

    func getAvailableConversions(for sourceType: FileType) -> [ConversionCategory] {
        switch sourceType {
        case .pdf:
            return [.documents, .images]
        case .docx, .pptx, .xlsx:
            return [.documents]
        case .jpg, .png:
            return [.documents, .images]
        case .mp4:
            return [.video]
        case .zip:
            return [.archives]
        }
    }

    func getRecommendedFormats(for sourceType: FileType) -> [ConversionFormat] {
        switch sourceType {
        case .pdf:
            return [
                ConversionFormat(name: "Word Document", extension: "docx", category: .documents, isRecommended: true),
                ConversionFormat(name: "JPEG Image", extension: "jpg", category: .images, isRecommended: true),
                ConversionFormat(name: "PNG Image", extension: "png", category: .images, isRecommended: false)
            ]
        case .jpg, .png:
            return [
                ConversionFormat(name: "PDF Document", extension: "pdf", category: .documents, isRecommended: true),
                ConversionFormat(name: "PNG Image", extension: "png", category: .images, isRecommended: true)
            ]
        default:
            return []
        }
    }

    func convertFile(at url: URL, to format: ConversionFormat) async throws -> FileItem {
        let sourceName = url.deletingPathExtension().lastPathComponent
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDir.appendingPathComponent("\(sourceName).\(format.extension)")

        switch format.extension {
        case "pdf":
            if url.pathExtension == "jpg" || url.pathExtension == "png" {
                try convertImageToPDF(at: url, output: outputURL)
            }
        case "jpg", "png":
            if url.pathExtension == "pdf" {
                try convertPDFToImage(at: url, output: outputURL, format: format.extension)
            } else {
                try convertImageFormat(at: url, output: outputURL)
            }
        default:
            throw ConverterError.unsupportedFormat
        }

        let attrs = try FileManager.default.attributesOfItem(atPath: outputURL.path)
        let targetType = FileType.allCases.first { $0.fileExtension == format.extension } ?? .pdf

        return FileItem(
            id: UUID(),
            name: "\(sourceName)",
            fileType: targetType,
            fileSize: attrs[.size] as? Int64 ?? 0,
            createdAt: Date(),
            modifiedAt: Date(),
            isLocked: false,
            isProFeature: true,
            url: outputURL
        )
    }

    func getFormatCount() -> Int {
        return 47
    }

    private func convertImageToPDF(at url: URL, output: URL) throws {
        guard let image = UIImage(contentsOfFile: url.path) else { throw ConverterError.invalidSource }
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: image.size))
        try pdfRenderer.writePDF(to: output) { context in
            context.beginPage()
            image.draw(at: .zero)
        }
    }

    private func convertPDFToImage(at url: URL, output: URL, format: String) throws {
        guard let doc = PDFDocument(url: url),
              let page = doc.page(at: 0) else { throw ConverterError.invalidSource }
        let bounds = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(bounds)
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
        guard let data = format == "jpg" ? image.jpegData(compressionQuality: 0.9) : image.pngData() else {
            throw ConverterError.invalidSource
        }
        try data.write(to: output)
    }

    private func convertImageFormat(at url: URL, output: URL) throws {
        guard let image = UIImage(contentsOfFile: url.path) else { throw ConverterError.invalidSource }
        let ext = output.pathExtension.lowercased()
        let data: Data?
        if ext == "jpg" {
            data = image.jpegData(compressionQuality: 0.9)
        } else {
            data = image.pngData()
        }
        guard let data = data else { throw ConverterError.invalidSource }
        try data.write(to: output)
    }
}

enum ConverterError: Error, LocalizedError {
    case unsupportedFormat
    case invalidSource

    var errorDescription: String? {
        switch self {
        case .unsupportedFormat: return "This conversion is not yet supported"
        case .invalidSource: return "Could not read the source file"
        }
    }
}
