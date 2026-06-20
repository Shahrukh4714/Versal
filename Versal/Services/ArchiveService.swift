import Foundation
import ZIPFoundation

final class ArchiveService {
    private let fileManager = FileManager.default

    func createZip(from items: [(url: URL, name: String)], at outputURL: URL) throws {
        guard let archive = Archive(url: outputURL, accessMode: .create) else {
            throw ArchiveError.creationFailed
        }
        for item in items {
            try archive.addEntry(with: item.name, relativeTo: item.url.deletingLastPathComponent())
        }
    }

    func extractZip(at url: URL, to destination: URL) throws -> [URL] {
        guard let archive = Archive(url: url, accessMode: .read) else {
            throw ArchiveError.invalidArchive
        }
        var extracted: [URL] = []
        for entry in archive {
            let entryURL = destination.appendingPathComponent(entry.path)
            try archive.extract(entry, to: entryURL)
            extracted.append(entryURL)
        }
        return extracted
    }

    func listContents(of url: URL) throws -> [String] {
        guard let archive = Archive(url: url, accessMode: .read) else {
            throw ArchiveError.invalidArchive
        }
        return archive.map { $0.path }
    }
}

enum ArchiveError: Error, LocalizedError {
    case creationFailed
    case invalidArchive

    var errorDescription: String? {
        switch self {
        case .creationFailed: return "Could not create archive"
        case .invalidArchive: return "Invalid or corrupted archive"
        }
    }
}
