import SwiftUI
import PDFKit

struct PDFViewer: View {
    @StateObject private var viewModel = PDFViewerViewModel()
    let fileURL: URL
    @State private var haptics = HapticService()
    @State private var showPaywall = false

    var body: some View {
        VStack(spacing: 0) {
            utilityToolbar

            PDFKitView(document: $viewModel.document)
                .overlay(
                    VStack {
                        HStack {
                            pageIndicator
                            Spacer()
                        }
                        .padding(8)
                        Spacer()
                    }
                )

            bottomToolbar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { navToolbar }
        .sheet(isPresented: $viewModel.showPagesSheet) { pagesSheet }
        .sheet(isPresented: $viewModel.showAIChat) { aiChatSheet }
        .sheet(isPresented: $showPaywall) { PaywallView() }
        .task { viewModel.loadPDF(at: fileURL) }
    }

    @ToolbarContentBuilder
    private var navToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 12) {
                Button(action: { haptics.trigger(.press) }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share PDF")
                Menu {
                    Button("Fill Forms", action: { haptics.trigger(.press) })
                    Button("Rename", action: { haptics.trigger(.press) })
                    Button("Duplicate", action: { haptics.trigger(.press) })
                    Button("Document Info", action: { haptics.trigger(.press) })
                    Divider()
                    Button("Delete", role: .destructive, action: { haptics.trigger(.destructive) })
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityLabel("More options")
            }
            .foregroundColor(.inkBlue)
        }
    }

    @State private var searchText = ""

    private var utilityToolbar: some View {
        HStack(spacing: 16) {
            toolbarButton(icon: "magnifyingglass", label: "Search")
                .onTapGesture { haptics.trigger(.press) }
            toolbarButton(icon: "lock", label: "Lock", isLocked: true)
                .onTapGesture { haptics.trigger(.press); showPaywall = true }

            HStack(spacing: 4) {
                LinearGradient(colors: [.aiGradientStart, .aiGradientEnd], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 22, height: 22)
                    .mask(Image(systemName: "brain.head.profile").font(.system(size: 14)))
                Text("AI")
                    .captionStyle()
                    .foregroundColor(.aiGradientStart)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.aiGradientStart.opacity(0.1))
            .cornerRadius(8)
            .onTapGesture { haptics.trigger(.press); viewModel.showAIChat = true }

            Spacer()

            toolbarButton(icon: "number", label: "Pages")
                .onTapGesture { haptics.trigger(.press); viewModel.showPagesSheet = true }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.surfaceCard)
    }

    private var bottomToolbar: some View {
        HStack(spacing: 0) {
            toolbarTab(icon: "signature", label: "Sign", isLocked: true)
                .onTapGesture { haptics.trigger(.press); showPaywall = true }
            toolbarTab(icon: "pencil.tip.crop.circle", label: "Markup", isLocked: false)
                .onTapGesture { haptics.trigger(.press) }
            toolbarTab(icon: "eye.slash", label: "Redact", isLocked: true)
                .onTapGesture { haptics.trigger(.press); showPaywall = true }
            toolbarTab(icon: "doc.on.doc", label: "Pages", isLocked: false)
                .onTapGesture { haptics.trigger(.press); viewModel.showPagesSheet = true }
            toolbarTab(icon: "square.and.arrow.up", label: "Share", isLocked: false)
                .onTapGesture { haptics.trigger(.press) }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.surfaceCard)
        .shadow(color: .black.opacity(0.05), radius: 0, x: 0, y: -1)
    }

    private func toolbarButton(icon: String, label: String, isLocked: Bool = false) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: IconSize.logomarkSmall))
            if isLocked {
                ProLockBadge()
            }
        }
        .foregroundColor(.inkBlue)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.inkWash)
        .cornerRadius(8)
    }

    private func toolbarTab(icon: String, label: String, isLocked: Bool) -> some View {
        VStack(spacing: 2) {
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: IconSize.inline))
                    .foregroundColor(isLocked ? .labelQuaternary : .labelPrimary)
                if isLocked {
                    ProLockBadge()
                        .offset(x: 8, y: -8)
                }
            }
            Text(label)
                .microStyle()
                .foregroundColor(isLocked ? .labelQuaternary : .labelPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }

    private func sendChatMessage() {
        let text = searchText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        haptics.trigger(.press)
        viewModel.chatMessages.append((text, true))
        searchText = ""
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            viewModel.chatMessages.append(("I'm an offline AI assistant. This feature requires the CoreML model to be downloaded.", false))
        }
    }

    private var pageIndicator: some View {
        Text("\(viewModel.currentPage + 1) of \(viewModel.totalPages)")
            .microStyle()
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.6))
            .cornerRadius(6)
    }

    private var pagesSheet: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button("Add Page") { haptics.trigger(.press) }
                        .bodyBoldStyle()
                        .foregroundColor(.inkBlue)
                    Button("Merge PDF") { haptics.trigger(.press) }
                        .bodyBoldStyle()
                        .foregroundColor(.inkBlue)
                    Spacer()
                }
                .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(0..<viewModel.totalPages, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.inkWash)
                                .frame(height: 160)
                                .overlay(
                                    Text("Page \(index + 1)")
                                        .captionStyle()
                                        .foregroundColor(.labelTertiary)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.selectedPages.contains(index) ? Color.inkBlue : Color.clear, lineWidth: 2.5)
                                )
                                .onTapGesture {
                                    if viewModel.selectedPages.contains(index) {
                                        viewModel.selectedPages.remove(index)
                                    } else {
                                        viewModel.selectedPages.insert(index)
                                    }
                                }
                        }
                    }
                    .padding()
                }

                if !viewModel.selectedPages.isEmpty {
                    HStack(spacing: 20) {
                        Button("Rotate") { haptics.trigger(.press) }
                        Button("Extract") { haptics.trigger(.press) }
                        Button("Delete", role: .destructive) { haptics.trigger(.destructive); viewModel.deleteSelectedPages() }
                    }
                    .padding()
                    .background(Color.surfaceCard)
                }
            }
            .navigationTitle("Pages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Select") {
                        viewModel.isSelectingPages.toggle()
                    }
                }
            }
        }
    }

    private var aiChatSheet: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.chatMessages.indices, id: \.self) { index in
                            let message = viewModel.chatMessages[index]
                            HStack {
                                if message.1 { Spacer() }
                                Text(message.0)
                                    .bodyStyle()
                                    .foregroundColor(.labelPrimary)
                                    .padding(10)
                                    .background(message.1 ? Color.inkBlue.opacity(0.1) : Color.inkWash)
                                    .cornerRadius(12)
                                if !message.1 { Spacer() }
                            }
                        }
                    }
                    .padding()
                }

                HStack(spacing: 8) {
                    TextField("Ask about this PDF...", text: $searchText)
                        .bodyStyle()
                        .padding(10)
                        .background(Color.inkWash)
                        .cornerRadius(10)
                        .onSubmit { sendChatMessage() }

                    Button(action: { sendChatMessage() }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.inkBlue)
                    }
                    .disabled(searchText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { viewModel.showAIChat = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

struct PDFKitView: UIViewRepresentable {
    @Binding var document: PDFDocument?

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}
