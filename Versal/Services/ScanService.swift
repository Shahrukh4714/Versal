import UIKit
import VisionKit

final class ScanService: NSObject, ScanServiceProtocol {
    private var continuation: CheckedContinuation<[ScanPage], Error>?

    func scanDocument() async throws -> [ScanPage] {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let root = windowScene.windows.first?.rootViewController else {
                    continuation.resume(throwing: ScanError.noRootViewController)
                    return
                }
                let scanner = VNDocumentCameraViewController()
                scanner.delegate = self
                root.present(scanner, animated: true)
            }
        }
    }

    func saveScannedPages(_ pages: [ScanPage], as filename: String) async throws -> FileItem {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDir.appendingPathComponent("\(filename).pdf")

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595.2, height: 841.8))
        try pdfRenderer.writePDF(to: fileURL) { context in
            for page in pages {
                context.beginPage()
                page.image.draw(in: CGRect(x: 0, y: 0, width: 595.2, height: 841.8))
            }
        }

        let attrs = try FileManager.default.attributesOfItem(atPath: fileURL.path)
        let fileSize = attrs[.size] as? Int64 ?? 0

        return FileItem(
            id: UUID(),
            name: filename,
            fileType: .pdf,
            fileSize: fileSize,
            createdAt: Date(),
            modifiedAt: Date(),
            isLocked: false,
            isProFeature: false,
            url: fileURL
        )
    }
}

extension ScanService: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        var pages: [ScanPage] = []
        for i in 0..<scan.pageCount {
            pages.append(ScanPage(image: scan.imageOfPage(at: i), index: i))
        }
        continuation?.resume(returning: pages)
        continuation = nil
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
        continuation?.resume(throwing: ScanError.cancelled)
        continuation = nil
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

enum ScanError: Error, LocalizedError {
    case noRootViewController
    case cancelled

    var errorDescription: String? {
        switch self {
        case .noRootViewController: return "Could not present camera"
        case .cancelled: return "Scan cancelled"
        }
    }
}
