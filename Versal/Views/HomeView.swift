import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showScanner = false
    @State private var showSettings = false
    @State private var haptics = HapticService()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.sectionVertical) {
                    header
                    quickActions
                    recentSection
                    activityLog
                    privacyFooter
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
            .background(Color.backgroundGrouped)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showScanner) { ScannerView() }
        .sheet(isPresented: $showSettings) { NavigationStack { SettingsView() } }
        .task { await viewModel.loadData() }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.greeting)
                    .captionStyle()
                    .foregroundColor(.labelSecondary)

                HStack(spacing: 8) {
                    LogomarkContainer(size: IconSize.logomark)
                    Text("Versal")
                        .font(.title2.weight(.heavy))
                        .foregroundColor(.labelPrimary)
                }
            }

            Spacer()

            Button(action: { haptics.trigger(.press); showSettings = true }) {
                Circle()
                    .fill(Color.inkWash)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: IconSize.inline))
                            .foregroundColor(.inkBlue)
                    )
            }
            .accessibilityLabel("Profile")
        }
        .padding(.top, 8)
    }

    private var quickActions: some View {
        HStack(spacing: 10) {
            scanTile
                .frame(maxWidth: .infinity)

            VStack(spacing: 10) {
                quickActionTile(icon: "arrow.triangle.2.circlepath", label: "Convert", action: { viewModel.didTapConvert() })
                quickActionTile(icon: "doc.on.doc", label: "Merge PDF", action: { viewModel.didTapConvert() })
                quickActionTile(icon: "folder", label: "All Files", action: { viewModel.didTapAllFiles() })
            }
            .frame(width: UIScreen.main.bounds.width * 0.38)
        }
        .frame(height: 200)
    }

    private var scanTile: some View {
        Button(action: {
            viewModel.didTapScan()
            showScanner = true
        }) {
            ZStack {
                InkBleedGradient()
                GrainOverlay()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Scan Document")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Point, capture,\ndone.")
                        .captionStyle()
                        .foregroundColor(.white.opacity(0.8))

                    Spacer()

                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                                .frame(width: 44, height: 32)
                            Image(systemName: "document.viewfinder")
                                .font(.system(size: IconSize.inline))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(14)
            }
        }
        .cornerRadius(CornerRadius.card)
        .cardShadow()
    }

    private func quickActionTile(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.smallIconContainer)
                        .fill(Color.inkWash)
                        .frame(width: IconSize.smallContainer, height: IconSize.smallContainer)
                    Image(systemName: icon)
                        .font(.system(size: IconSize.logomarkSmall))
                        .foregroundColor(.inkBlue)
                }

                Text(label)
                    .bodyBoldStyle()
                    .foregroundColor(.labelPrimary)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.surfaceCard)
            .cornerRadius(CornerRadius.card)
            .cardShadow()
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent")
                .sectionHeaderStyle()
                .foregroundColor(.labelPrimary)

            if viewModel.recentFiles.isEmpty {
                Text("No recent files")
                    .bodyStyle()
                    .foregroundColor(.labelTertiary)
            } else {
                HStack(alignment: .center, spacing: 16) {
                    fanDeck
                    recentDetails
                }
            }
        }
    }

    private var fanDeck: some View {
        ZStack {
            ForEach(Array(viewModel.recentFiles.enumerated()), id: \.element.id) { index, file in
                let rotations: [Double] = [-6, 3, -2]
                let offsets: [CGFloat] = [0, 8, 16]

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.surfaceCard)
                    .frame(width: 80, height: 100)
                    .rotationEffect(.degrees(rotations[safe: index] ?? 0))
                    .offset(x: offsets[safe: index] ?? 0)
                    .shadow(color: .black.opacity(index == 0 ? 0.12 : 0.04), radius: index == 0 ? 4 : 2, x: 0, y: 1)
                    .overlay(
                        VStack(spacing: 4) {
                            FileTypeChip(fileType: file.fileType)
                            Text(file.name)
                                .microStyle()
                                .foregroundColor(.labelPrimary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 4)
                        }
                        .padding(.vertical, 8)
                    )
            }
        }
        .frame(width: 100, height: 110)
    }

    private var recentDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let latest = viewModel.recentFiles.first {
                Text(latest.name)
                    .bodyBoldStyle()
                    .foregroundColor(.labelPrimary)
                    .lineLimit(2)

                Text(latest.formattedSize)
                    .captionStyle()
                    .foregroundColor(.labelTertiary)

                Text(latest.formattedDate)
                    .captionStyle()
                    .foregroundColor(.labelSecondary)
            }

            Spacer()

            if viewModel.recentFiles.count > 1 {
                Text("+\(viewModel.recentFiles.count - 1) more files")
                    .captionStyle()
                    .foregroundColor(.inkBlue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var activityLog: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Activity Log")
                    .sectionHeaderStyle()
                    .foregroundColor(.labelPrimary)

                Text("Full transparency — every action, on this device only")
                    .captionStyle()
                    .foregroundColor(.labelTertiary)
            }

            CardView {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.activityLog.enumerated()), id: \.element.id) { index, event in
                        activityRow(event)
                        if index < viewModel.activityLog.count - 1 {
                            Divider()
                                .padding(.leading, 50)
                        }
                    }
                }
            }
        }
    }

    private func activityRow(_ event: ActivityEvent) -> some View {
        HStack(spacing: 12) {
            if event.isSystemEvent {
                ZStack {
                    Circle()
                        .fill(Color.inkWash)
                        .frame(width: 36, height: 36)
                    Image(systemName: "faceid")
                        .font(.system(size: IconSize.logomarkSmall))
                        .foregroundColor(.inkBlue)
                }
            } else {
                Image(systemName: "doc.text")
                    .font(.system(size: IconSize.logomarkSmall))
                    .foregroundColor(.fileIconColor(for: .pdf))
                    .frame(width: 36, height: 36)
                    .background(Color.fileBackgroundColor(for: .pdf))
                    .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(event.description)
                    .bodyStyle()
                    .foregroundColor(.labelPrimary)
            }

            Spacer()

            Text(event.relativeTimestamp)
                .captionStyle()
                .foregroundColor(.labelTertiary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
    }

    private var privacyFooter: some View {
        HStack(spacing: 6) {
            LogomarkInline()
            Text("All files stay on your device.")
                .captionStyle()
                .foregroundColor(.labelTertiary)
            Text("Learn how")
                .captionStyle()
                .foregroundColor(.inkBlue)
        }
        .padding(.vertical, 12)
        .padding(.bottom, 8)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
