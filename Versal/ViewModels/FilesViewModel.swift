import Foundation

@MainActor
final class FilesViewModel: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var folders: [Folder] = []
    @Published var searchText: String = ""
    @Published var selectedSort: SortOption = .date
    @Published var isSelectMode: Bool = false
    @Published var selectedFiles: Set<UUID> = []
    @Published var isGridView: Bool = true
    @Published var isLoading: Bool = false

    enum SortOption: String, CaseIterable {
        case date = "Date"
        case name = "Name"
        case size = "Size"
    }

    private let fileService: FileServiceProtocol
    private let hapticService: HapticServiceProtocol

    init(
        fileService: FileServiceProtocol = FileService(),
        hapticService: HapticServiceProtocol = HapticService()
    ) {
        self.fileService = fileService
        self.hapticService = hapticService
    }

    func loadFiles() async {
        isLoading = true
        do {
            files = try await fileService.listFiles()
            folders = try await fileService.getSmartFolders()
        } catch {
            files = []
        }
        isLoading = false
    }

    func searchFiles() async {
        guard !searchText.isEmpty else {
            await loadFiles()
            return
        }
        do {
            files = try await fileService.searchFiles(query: searchText)
        } catch {
            files = []
        }
    }

    func sortedFiles() -> [FileItem] {
        switch selectedSort {
        case .date: return files.sorted { $0.createdAt > $1.createdAt }
        case .name: return files.sorted { $0.name < $1.name }
        case .size: return files.sorted { $0.fileSize > $1.fileSize }
        }
    }

    func deleteSelected() {
        hapticService.trigger(.destructive)
        Task {
            for id in selectedFiles {
                if let file = files.first(where: { $0.id == id }) {
                    try? await fileService.deleteFile(file)
                }
            }
            selectedFiles.removeAll()
            isSelectMode = false
            await loadFiles()
        }
    }

    func toggleSelectMode() {
        isSelectMode.toggle()
        if !isSelectMode { selectedFiles.removeAll() }
    }
}
