import Foundation
import PDFKit

@MainActor
final class PDFViewerViewModel: ObservableObject {
    @Published var document: PDFDocument?
    @Published var currentPage: Int = 0
    @Published var totalPages: Int = 0
    @Published var showPagesSheet: Bool = false
    @Published var showAIChat: Bool = false
    @Published var chatMessages: [(String, Bool)] = [] // (text, isUser)
    @Published var isSelectingPages: Bool = false
    @Published var selectedPages: Set<Int> = []

    var fileURL: URL?

    private let pdfService: PDFServiceProtocol
    private let aiService: AIServiceProtocol

    init(
        pdfService: PDFServiceProtocol = PDFService(),
        aiService: AIServiceProtocol = AIService()
    ) {
        self.pdfService = pdfService
        self.aiService = aiService
    }

    func loadPDF(at url: URL) {
        fileURL = url
        document = pdfService.openPDF(at: url)
        totalPages = document?.pageCount ?? 0
    }

    func sendMessage(_ text: String) {
        guard let url = fileURL else { return }
        chatMessages.append((text, true))

        Task {
            do {
                let response = try await aiService.chatWithPDF(documentURL: url, question: text)
                chatMessages.append((response, false))
            } catch {
                chatMessages.append(("Sorry, I couldn't process that request.", false))
            }
        }
    }

    func deleteSelectedPages() {
        guard let url = fileURL else { return }
        Task {
            for index in selectedPages.sorted(by: >) {
                try? await pdfService.deletePage(at: url, at: index)
            }
            loadPDF(at: url)
            selectedPages.removeAll()
            isSelectingPages = false
        }
    }
}
