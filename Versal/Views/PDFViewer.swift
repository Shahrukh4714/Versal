import SwiftUI
import PDFKit

struct PDFViewer: View {
    @StateObject private var viewModel = PDFViewerViewModel()
    let fileURL: URL

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
        .task { viewModel.loadPDF(at: fileURL) }
    }

    @ToolbarContentBuilder
    private var navToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
                Menu {
                    Button("Fill Forms", action: {})
                    Button("Rename", action: {})
                    Button("Duplicate", action: {})
                    Button("Document Info", action: {})
                    Divider()
                    Button("Delete", role: .destructive, action: {})
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .foregroundColor(.inkBlue)
        }
    }

    private var utilityToolbar: some View {
        HStack(spacing: 16) {
            toolbarButton(icon: "magnifyingglass", label: "Search")
            toolbarButton(icon: "lock", label: "Lock", isLocked: true)

            HStack(spacing: 4) {
                LinearGradient(colors: [.aiGradientStart, .aiGradientEnd], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 22, height: 22)
                    .mask(Image(systemName: "brain.head.profile").font(.system(size: 14)))
                Text("AI")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.aiGradientStart)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.aiGradientStart.opacity(0.1))
            .cornerRadius(8)
            .onTapGesture { viewModel.showAIChat = true }

            Spacer()

            toolbarButton(icon: "number", label: "Pages")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.surfaceCard)
    }

    private var bottomToolbar: some View {
        HStack(spacing: 0) {
            toolbarTab(icon: "signature", label: "Sign", isLocked: true)
            toolbarTab(icon: "pencil.tip.crop.circle", label: "Markup", isLocked: false)
            toolbarTab(icon: "eye.slash", label: "Redact", isLocked: true)
            toolbarTab(icon: "doc.on.doc", label: "Pages", isLocked: false)
                .onTapGesture { viewModel.showPagesSheet = true }
            toolbarTab(icon: "square.and.arrow.up", label: "Share", isLocked: false)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.surfaceCard)
        .shadow(color: .black.opacity(0.05), radius: 0, x: 0, y: -1)
    }

    private func toolbarButton(icon: String, label: String, isLocked: Bool = false) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
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
                    .font(.system(size: 18))
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
                    Button("Add Page") {}
                        .bodyBoldStyle()
                        .foregroundColor(.inkBlue)
                    Button("Merge PDF") {}
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
                        Button("Rotate") {}
                        Button("Extract") {}
                        Button("Delete", role: .destructive) { viewModel.deleteSelectedPages() }
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
                    TextField("Ask about this PDF...", text: .constant(""))
                        .bodyStyle()
                        .padding(10)
                        .background(Color.inkWash)
                        .cornerRadius(10)

                    Button(action: {}) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.inkBlue)
                    }
                }
                .padding()
            }
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { viewModel.showAIChat = false }
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
