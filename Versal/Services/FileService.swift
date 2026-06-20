import Foundation
import UIKit

final class FileService: FileServiceProtocol {
    private let fileManager = FileManager.default

    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func listFiles() async throws -> [FileItem] {
        let contents = try fileManager.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: [.fileSizeKey, .creationDateKey, .contentModificationDateKey]
        )

        return contents.compactMap { url -> FileItem? in
            guard let attrs = try? fileManager.attributesOfItem(atPath: url.path),
                  let fileType = fileTypeForURL(url) else { return nil }

            let fileSize = attrs[.size] as? Int64 ?? 0
            let created = attrs[.creationDate] as? Date ?? Date()
            let modified = attrs[.modificationDate] as? Date ?? Date()

            return FileItem(
                id: UUID(),
                name: url.deletingPathExtension().lastPathComponent,
                fileType: fileType,
                fileSize: fileSize,
                createdAt: created,
                modifiedAt: modified,
                isLocked: false,
                isProFeature: false,
                url: url
            )
        }
        .sorted { $0.createdAt > $1.createdAt }
    }

    func deleteFile(_ file: FileItem) async throws {
        try fileManager.removeItem(at: file.url)
    }

    func renameFile(_ file: FileItem, to newName: String) async throws -> FileItem {
        let newURL = file.url.deletingLastPathComponent()
            .appendingPathComponent(newName)
            .appendingPathExtension(file.fileType.fileExtension)
        try fileManager.moveItem(at: file.url, to: newURL)
        return FileItem(
            id: file.id,
            name: newName,
            fileType: file.fileType,
            fileSize: file.fileSize,
            createdAt: file.createdAt,
            modifiedAt: Date(),
            isLocked: file.isLocked,
            isProFeature: file.isProFeature,
            url: newURL
        )
    }

    func moveFile(_ file: FileItem, to folder: String) async throws {
        let folderURL = documentsURL.appendingPathComponent(folder)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
        let newURL = folderURL.appendingPathComponent(file.name).appendingPathExtension(file.fileType.fileExtension)
        try fileManager.moveItem(at: file.url, to: newURL)
    }

    func duplicateFile(_ file: FileItem) async throws -> FileItem {
        let newName = file.name + " copy"
        let newURL = file.url.deletingLastPathComponent()
            .appendingPathComponent(newName)
            .appendingPathExtension(file.fileType.fileExtension)
        try fileManager.copyItem(at: file.url, to: newURL)

        let attrs = try fileManager.attributesOfItem(atPath: newURL.path)
        let fileSize = attrs[.size] as? Int64 ?? 0

        return FileItem(
            id: UUID(),
            name: newName,
            fileType: file.fileType,
            fileSize: fileSize,
            createdAt: Date(),
            modifiedAt: Date(),
            isLocked: false,
            isProFeature: file.isProFeature,
            url: newURL
        )
    }

    func searchFiles(query: String) async throws -> [FileItem] {
        let files = try await listFiles()
        return files.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    func getSmartFolders() async throws -> [Folder] {
        let files = try await listFiles()
        let grouped = Dictionary(grouping: files) { $0.fileType }

        return grouped.map { type, items in
            Folder(
                id: UUID(),
                name: "\(type.rawValue)s",
                fileCount: items.count,
                colorHex: Color.fileIconColor(for: type).description
            )
        }
        .sorted { $0.name < $1.name }
    }

    private func fileTypeForURL(_ url: URL) -> FileType? {
        let ext = url.pathExtension.lowercased()
        return FileType.allCases.first { $0.fileExtension == ext }
    }
}
