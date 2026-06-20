import Foundation
import UIKit

protocol ScanServiceProtocol {
    func scanDocument() async throws -> [ScanPage]
    func saveScannedPages(_ pages: [ScanPage], as filename: String) async throws -> FileItem
}
