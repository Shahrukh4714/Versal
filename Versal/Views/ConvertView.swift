import SwiftUI

struct ConvertView: View {
    @StateObject private var viewModel = ConverterViewModel()
    @State private var haptics = HapticService()

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.step {
                case .browse:
                    browseStep
                case .selectFormat:
                    formatSelectionStep
                case .converting:
                    convertingStep
                case .complete:
                    completionStep
                }
            }
            .background(Color.backgroundGrouped)
            .navigationTitle("Convert")
        }
    }

    private var browseStep: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Available formats")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)

                Button(action: {}) {
                    ZStack {
                        InkBleedGradient()
                            .cornerRadius(CornerRadius.card)
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Select a File")
                                    .sectionHeaderStyle()
                                    .foregroundColor(.white)
                                Text("Tap to browse files")
                                    .captionStyle()
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(16)
                    }
                    .frame(height: 100)
                    .cardShadow()
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(ConversionCategory.allCases, id: \.rawValue) { category in
                        categoryCard(category)
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                HStack(spacing: 4) {
                    ProLockBadge()
                    Text("Batch conversion and premium formats require Pro")
                        .captionStyle()
                        .foregroundColor(.labelTertiary)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
            .padding(.vertical, 16)
        }
    }

    private func categoryCard(_ category: ConversionCategory) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category.rawValue)
                .bodyBoldStyle()
                .foregroundColor(.labelPrimary)

            Text("47+ formats")
                .captionStyle()
                .foregroundColor(.labelSecondary)

            HStack(spacing: 4) {
                ForEach(0..<3) { _ in
                    Text("PDF")
                        .microStyle()
                        .foregroundColor(.inkBlue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.inkWash)
                        .cornerRadius(4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.surfaceCard)
        .cornerRadius(CornerRadius.card)
        .cardShadow()
    }

    private var formatSelectionStep: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let file = viewModel.sourceFile {
                    HStack {
                        FileIconView(fileType: file.fileType, size: 40)
                        VStack(alignment: .leading) {
                            Text(file.name).bodyBoldStyle()
                            Text(file.formattedSize).captionStyle().foregroundColor(.labelTertiary)
                        }
                        Spacer()
                        Button("Change") {}
                            .captionStyle()
                            .foregroundColor(.inkBlue)
                    }
                    .padding()
                    .background(Color.surfaceCard)
                    .cornerRadius(CornerRadius.card)
                    .padding(.horizontal, Spacing.screenHorizontal)
                }

                if !viewModel.recommendedFormats.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recommended")
                            .sectionHeaderStyle()
                            .padding(.horizontal, Spacing.screenHorizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.recommendedFormats) { format in
                                    recommendedCard(format)
                                }
                            }
                            .padding(.horizontal, Spacing.screenHorizontal)
                        }
                    }
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(viewModel.availableCategories, id: \.rawValue) { category in
                        Button(action: {}) {
                            Text(category.rawValue)
                                .bodyBoldStyle()
                                .foregroundColor(.inkBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.inkWash)
                                .cornerRadius(CornerRadius.card)
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }

    private func recommendedCard(_ format: ConversionFormat) -> some View {
        Button(action: {
            viewModel.selectedFormat = format
            viewModel.startConversion()
            haptics.trigger(.press)
        }) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.inkWash)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "doc")
                            .font(.system(size: 24))
                            .foregroundColor(.inkBlue)
                    )
                Text(format.name)
                    .captionStyle()
                    .foregroundColor(.labelPrimary)
                Text("." + format.extension)
                    .microStyle()
                    .foregroundColor(.labelTertiary)
            }
            .frame(width: 100)
            .padding(8)
            .background(Color.surfaceCard)
            .cornerRadius(CornerRadius.card)
            .cardShadow()
        }
    }

    private var convertingStep: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                ProgressRing(progress: viewModel.conversionProgress, lineWidth: 10)
                    .frame(width: 120, height: 120)

                VStack(spacing: 4) {
                    Text("\(Int(viewModel.conversionProgress * 100))%")
                        .heroHeadlineStyle()
                        .foregroundColor(.inkBlue)
                    Text("Converting")
                        .microStyle()
                        .foregroundColor(.labelSecondary)
                }
            }

            if let file = viewModel.sourceFile, let format = viewModel.selectedFormat {
                HStack(spacing: 20) {
                    FileIconView(fileType: file.fileType, size: 48)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.labelTertiary)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.inkWash)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text("." + format.extension)
                                .microStyle()
                                .foregroundColor(.inkBlue)
                        )
                }
                .opacity(viewModel.conversionProgress > 0.5 ? 1 : 0.3)
            }

            Spacer()
        }
    }

    private var completionStep: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.successGreen)
                .onAppear { haptics.trigger(.success) }

            Text("Conversion complete")
                .heroHeadlineStyle()
                .foregroundColor(.labelPrimary)

            if let result = viewModel.convertedFile {
                Text("\(result.formattedSize)")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)
            }

            HStack(spacing: 6) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.successGreen)
                Text("Processed entirely on-device")
                    .captionStyle()
                    .foregroundColor(.successGreen)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.successGreen.opacity(0.1))
            .cornerRadius(12)

            Spacer()

            Button(action: { haptics.trigger(.press); viewModel.reset() }) {
                Text("Convert Another")
                    .bodyBoldStyle()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.inkBlue)
                    .cornerRadius(CornerRadius.button)
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }
}
