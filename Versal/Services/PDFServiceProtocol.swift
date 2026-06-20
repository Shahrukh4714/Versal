import Foundation
import PDFKit

protocol PDFServiceProtocol {
    func openPDF(at url: URL) -> PDFDocument?
    func mergePDFs(_ urls: [URL]) async throws -> FileItem
    func splitPDF(at url: URL, atPage pageIndex: Int) async throws -> [FileItem]
    func addPage(to url: URL, from otherURL: URL) async throws
    func deletePage(at url: URL, at index: Int) async throws
    func rotatePage(at url: URL, at index: Int, degrees: Int) async throws
    func extractPages(from url: URL, range: ClosedRange<Int>) async throws -> FileItem
    func compressPDF(at url: URL) async throws -> FileItem
    func addWatermark(to url: URL, text: String) async throws
    func addPageNumbers(to url: URL) async throws
}
