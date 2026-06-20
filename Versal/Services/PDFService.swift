import Foundation
import PDFKit

final class PDFService: PDFServiceProtocol {
    func openPDF(at url: URL) -> PDFDocument? {
        PDFDocument(url: url)
    }

    func mergePDFs(_ urls: [URL]) async throws -> FileItem {
        let mergedDoc = PDFDocument()
        var pageIndex = 0

        for url in urls {
            guard let doc = PDFDocument(url: url) else { continue }
            for i in 0..<doc.pageCount {
                guard let page = doc.page(at: i) else { continue }
                mergedDoc.insert(page, at: pageIndex)
                pageIndex += 1
            }
        }

        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDir.appendingPathComponent("Merged-\(UUID().uuidString.prefix(6)).pdf")
        mergedDoc.write(to: outputURL)

        let attrs = try FileManager.default.attributesOfItem(atPath: outputURL.path)
        return FileItem(
            id: UUID(),
            name: "Merged Document",
            fileType: .pdf,
            fileSize: attrs[.size] as? Int64 ?? 0,
            createdAt: Date(),
            modifiedAt: Date(),
            isLocked: false,
            isProFeature: true,
            url: outputURL
        )
    }

    func splitPDF(at url: URL, atPage pageIndex: Int) async throws -> [FileItem] {
        guard let doc = PDFDocument(url: url) else { throw PDFError.invalidDocument }

        let doc1 = PDFDocument()
        let doc2 = PDFDocument()

        for i in 0..<pageIndex {
            guard let page = doc.page(at: i) else { continue }
            doc1.insert(page, at: i)
        }

        for i in pageIndex..<doc.pageCount {
            guard let page = doc.page(at: i) else { continue }
            doc2.insert(page, at: i - pageIndex)
        }

        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url1 = documentsDir.appendingPathComponent("Split-1.pdf")
        let url2 = documentsDir.appendingPathComponent("Split-2.pdf")
        doc1.write(to: url1)
        doc2.write(to: url2)

        return [
            FileItem(id: UUID(), name: "Split-1", fileType: .pdf, fileSize: 0, createdAt: Date(), modifiedAt: Date(), isLocked: false, isProFeature: true, url: url1),
            FileItem(id: UUID(), name: "Split-2", fileType: .pdf, fileSize: 0, createdAt: Date(), modifiedAt: Date(), isLocked: false, isProFeature: true, url: url2)
        ]
    }

    func addPage(to url: URL, from otherURL: URL) async throws {
        guard let doc = PDFDocument(url: url),
              let other = PDFDocument(url: otherURL) else { throw PDFError.invalidDocument }
        for i in 0..<other.pageCount {
            guard let page = other.page(at: i) else { continue }
            doc.insert(page, at: doc.pageCount)
        }
        doc.write(to: url)
    }

    func deletePage(at url: URL, at index: Int) async throws {
        guard let doc = PDFDocument(url: url) else { throw PDFError.invalidDocument }
        doc.removePage(at: index)
        doc.write(to: url)
    }

    func rotatePage(at url: URL, at index: Int, degrees: Int) async throws {
        guard let doc = PDFDocument(url: url),
              let page = doc.page(at: index) else { throw PDFError.invalidDocument }
        page.rotation += degrees
        doc.write(to: url)
    }

    func extractPages(from url: URL, range: ClosedRange<Int>) async throws -> FileItem {
        guard let doc = PDFDocument(url: url) else { throw PDFError.invalidDocument }
        let extracted = PDFDocument()
        var idx = 0
        for i in range {
            guard let page = doc.page(at: i) else { continue }
            extracted.insert(page, at: idx)
            idx += 1
        }
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDir.appendingPathComponent("Extracted-\(UUID().uuidString.prefix(6)).pdf")
        extracted.write(to: outputURL)

        let attrs = try FileManager.default.attributesOfItem(atPath: outputURL.path)
        return FileItem(id: UUID(), name: "Extracted Pages", fileType: .pdf, fileSize: attrs[.size] as? Int64 ?? 0, createdAt: Date(), modifiedAt: Date(), isLocked: false, isProFeature: true, url: outputURL)
    }

    func compressPDF(at url: URL) async throws -> FileItem {
        guard let doc = PDFDocument(url: url) else { throw PDFError.invalidDocument }
        let data = doc.dataRepresentation
        let compressed = NSData(data: data)
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDir.appendingPathComponent("Compressed-\(url.lastPathComponent)")
        try compressed.write(to: outputURL, options: .atomic)

        let attrs = try FileManager.default.attributesOfItem(atPath: outputURL.path)
        return FileItem(id: UUID(), name: "Compressed-\(url.deletingPathExtension().lastPathComponent)", fileType: .pdf, fileSize: attrs[.size] as? Int64 ?? 0, createdAt: Date(), modifiedAt: Date(), isLocked: false, isProFeature: true, url: outputURL)
    }

    func addWatermark(to url: URL, text: String) async throws {
        guard let doc = PDFDocument(url: url) else { throw PDFError.invalidDocument }
        for i in 0..<doc.pageCount {
            guard let page = doc.page(at: i) else { continue }
            let bounds = page.bounds(for: .mediaBox)
            let annotation = PDFAnnotation(bounds: CGRect(x: bounds.midX - 100, y: bounds.midY - 10, width: 200, height: 20), forType: .freeText, withProperties: nil)
            annotation.contents = text
            annotation.font = UIFont.systemFont(ofSize: 18)
            annotation.color = UIColor.gray.withAlphaComponent(0.3)
            page.addAnnotation(annotation)
        }
        doc.write(to: url)
    }

    func addPageNumbers(to url: URL) async throws {
        guard let doc = PDFDocument(url: url) else { throw PDFError.invalidDocument }
        for i in 0..<doc.pageCount {
            guard let page = doc.page(at: i) else { continue }
            let bounds = page.bounds(for: .mediaBox)
            let annotation = PDFAnnotation(bounds: CGRect(x: bounds.midX - 15, y: 10, width: 30, height: 20), forType: .freeText, withProperties: nil)
            annotation.contents = "\(i + 1)"
            annotation.font = UIFont.systemFont(ofSize: 10)
            annotation.color = UIColor.gray
            page.addAnnotation(annotation)
        }
        doc.write(to: url)
    }
}

enum PDFError: Error, LocalizedError {
    case invalidDocument
    var errorDescription: String? { "Invalid PDF document" }
}
