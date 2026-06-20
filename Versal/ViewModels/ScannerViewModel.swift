import Foundation
import UIKit

@MainActor
final class ScannerViewModel: ObservableObject {
    @Published var scannedPages: [ScanPage] = []
    @Published var isScanning: Bool = false
    @Published var showReview: Bool = false
    @Published var selectedFilter: ScanFilter = .original
    @Published var savedFile: FileItem?
    @Published var errorMessage: String?

    enum ScanFilter: String, CaseIterable {
        case original = "Original"
        case enhanced = "Enhanced"
        case blackAndWhite = "B&W"
        case whiteboard = "Whiteboard"
    }

    private let scanService: ScanServiceProtocol
    private let fileService: FileServiceProtocol
    private let hapticService: HapticServiceProtocol

    init(
        scanService: ScanServiceProtocol = ScanService(),
        fileService: FileServiceProtocol = FileService(),
        hapticService: HapticServiceProtocol = HapticService()
    ) {
        self.scanService = scanService
        self.fileService = fileService
        self.hapticService = hapticService
    }

    func startScan() {
        isScanning = true
        Task {
            do {
                let pages = try await scanService.scanDocument()
                scannedPages.append(contentsOf: pages)
                showReview = true
                hapticService.trigger(.success)
            } catch {
                errorMessage = error.localizedDescription
            }
            isScanning = false
        }
    }

    func saveScan(filename: String = "Scan-\(Date().timeIntervalSince1970)") {
        Task {
            do {
                let file = try await scanService.saveScannedPages(scannedPages, as: filename)
                savedFile = file
                scannedPages.removeAll()
                showReview = false
                hapticService.trigger(.success)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func retake() {
        showReview = false
        scannedPages.removeAll()
        startScan()
    }

    func applyFilter(_ filter: ScanFilter) {
        selectedFilter = filter
    }
}
