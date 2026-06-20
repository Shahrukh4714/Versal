import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recentFiles: [FileItem] = []
    @Published var activityLog: [ActivityEvent] = []
    @Published var greeting: String = ""
    @Published var errorMessage: String?

    private let fileService: FileServiceProtocol
    private let hapticService: HapticServiceProtocol

    init(
        fileService: FileServiceProtocol = FileService(),
        hapticService: HapticServiceProtocol = HapticService()
    ) {
        self.fileService = fileService
        self.hapticService = hapticService
        updateGreeting()
    }

    func loadData() async {
        do {
            let files = try await fileService.listFiles()
            recentFiles = Array(files.prefix(3))
            activityLog = generateMockActivity(from: files)
        } catch {
            errorMessage = error.localizedDescription
            activityLog = []
        }
    }

    func didTapScan() {
        hapticService.trigger(.press)
    }

    func didTapConvert() {
        hapticService.trigger(.press)
    }

    func didTapAllFiles() {
        hapticService.trigger(.press)
    }

    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: greeting = "Good morning"
        case 12..<17: greeting = "Good afternoon"
        default: greeting = "Good evening"
        }
    }

    private func generateMockActivity(from files: [FileItem]) -> [ActivityEvent] {
        var events: [ActivityEvent] = []

        for file in files.prefix(2) {
            events.append(ActivityEvent(
                id: UUID(),
                type: .fileScanned(filename: file.name),
                timestamp: file.createdAt,
                isSystemEvent: false
            ))
        }

        events.append(ActivityEvent(
            id: UUID(),
            type: .faceIDEnabled,
            timestamp: Date().addingTimeInterval(-3600),
            isSystemEvent: true
        ))

        return events.sorted { $0.timestamp > $1.timestamp }
    }
}
