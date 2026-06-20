import Foundation

@MainActor
final class ConverterViewModel: ObservableObject {
    @Published var step: Step = .browse
    @Published var sourceFile: FileItem?
    @Published var availableCategories: [ConversionCategory] = []
    @Published var recommendedFormats: [ConversionFormat] = []
    @Published var selectedFormat: ConversionFormat?
    @Published var conversionProgress: Double = 0
    @Published var isConverting: Bool = false
    @Published var convertedFile: FileItem?

    enum Step {
        case browse
        case selectFormat
        case converting
        case complete
    }

    private let converterService: ConverterServiceProtocol
    private let purchaseService: PurchaseServiceProtocol

    init(
        converterService: ConverterServiceProtocol = ConverterService(),
        purchaseService: PurchaseServiceProtocol = PurchaseService()
    ) {
        self.converterService = converterService
        self.purchaseService = purchaseService
    }

    func selectSource(_ file: FileItem) {
        sourceFile = file
        availableCategories = converterService.getAvailableConversions(for: file.fileType)
        recommendedFormats = converterService.getRecommendedFormats(for: file.fileType)
        step = .selectFormat
    }

    func startConversion() {
        guard let file = sourceFile, let format = selectedFormat else { return }
        isConverting = true
        step = .converting

        Task {
            do {
                // Simulate progress
                for progress in stride(from: 0, through: 1, by: 0.1) {
                    conversionProgress = progress
                    try await Task.sleep(nanoseconds: 200_000_000)
                }

                let result = try await converterService.convertFile(at: file.url, to: format)
                convertedFile = result
                step = .complete
            } catch {
                step = .browse
            }
            isConverting = false
        }
    }

    func reset() {
        step = .browse
        sourceFile = nil
        selectedFormat = nil
        conversionProgress = 0
        convertedFile = nil
    }
}
