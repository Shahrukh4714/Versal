import Foundation

protocol FileServiceProtocol {
    func listFiles() async throws -> [FileItem]
    func deleteFile(_ file: FileItem) async throws
    func renameFile(_ file: FileItem, to newName: String) async throws -> FileItem
    func moveFile(_ file: FileItem, to folder: String) async throws
    func duplicateFile(_ file: FileItem) async throws -> FileItem
    func searchFiles(query: String) async throws -> [FileItem]
    func getSmartFolders() async throws -> [Folder]
}
