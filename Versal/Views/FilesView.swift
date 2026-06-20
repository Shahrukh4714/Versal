import SwiftUI

struct FilesView: View {
    @StateObject private var viewModel = FilesViewModel()
    @State private var showDeleteConfirmation = false
    @State private var searchTask: Task<Void, Never>?
    @State private var showScanner = false
    @State private var selectedFilter = "All"
    @State private var haptics = HapticService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.files.isEmpty {
                    ProgressView("Loading files…")
                        .frame(maxHeight: .infinity)
                } else if viewModel.files.isEmpty {
                    EmptyStateView(
                        title: "No files yet",
                        subtitle: "Scan your first document to get started",
                        actionTitle: "Scan Your First Document",
                        action: { showScanner = true }
                    )
                } else {
                    fileList
                }
            }
            .background(Color.backgroundGrouped)
            .navigationTitle("Files")
            .toolbar { toolbarContent }
            .sheet(isPresented: $showDeleteConfirmation) {
                deleteConfirmationSheet
            }
            .fullScreenCover(isPresented: $showScanner) { ScannerView() }
            .task { await viewModel.loadFiles() }
            .onChange(of: viewModel.searchText) { _, _ in
                searchTask?.cancel()
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    await viewModel.searchFiles()
                }
            }
            .alert("Error", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: .init(
                get: { selectedFileURL != nil },
                set: { if !$0 { selectedFileURL = nil } }
            )) {
                if let url = selectedFileURL, url.pathExtension.lowercased() == "pdf" {
                    NavigationStack { PDFViewer(fileURL: url) }
                } else {
                    Text("Preview not available for this file type")
                        .presentationDetents([.height(200)])
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !viewModel.isSelectMode {
                Button("Select") {
                    viewModel.toggleSelectMode()
                }
                .foregroundColor(.inkBlue)
            }
        }

        if viewModel.isSelectMode {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    viewModel.toggleSelectMode()
                }
                .foregroundColor(.inkBlue)
            }
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.labelTertiary)
            TextField("Search files and text inside scans", text: $viewModel.searchText)
                .bodyStyle()
                .foregroundColor(.labelPrimary)
        }
        .padding(10)
        .background(Color.surfaceCard)
        .cornerRadius(10)
        .padding(.horizontal, Spacing.screenHorizontal)
        .padding(.vertical, 8)
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(["All", "PDF", "Images", "Docs", "Audio", "Video", "Archives"], id: \.self) { chip in
                    Text(chip)
                        .captionStyle()
                        .foregroundColor(selectedFilter == chip ? .white : .inkBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedFilter == chip ? Color.inkBlue : Color.inkWash)
                        .cornerRadius(12)
                        .onTapGesture {
                            haptics.trigger(.press)
                            selectedFilter = chip
                        }
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }

    private var folderScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.folders) { folder in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.inkWash)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "folder")
                                    .font(.system(size: IconSize.toolbar))
                                    .foregroundColor(.inkBlue)
                            )
                        Text(folder.name)
                            .microStyle()
                            .foregroundColor(.labelPrimary)
                        Text("\(folder.fileCount) files")
                            .captionStyle()
                            .foregroundColor(.labelTertiary)
                    }
                    .frame(width: 70)
                }
            }
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }

    private var sortControl: some View {
        HStack {
            Spacer()
            Menu {
                ForEach(FilesViewModel.SortOption.allCases, id: \.rawValue) { option in
                    Button(option.rawValue) {
                        viewModel.selectedSort = option
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(viewModel.selectedSort.rawValue)
                        .captionStyle()
                        .foregroundColor(.inkBlue)
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.inkBlue)
                }
            }

            Button(action: { viewModel.isGridView.toggle() }) {
                Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.2x2")
                    .font(.system(size: IconSize.inline))
                    .foregroundColor(.inkBlue)
            }
            .accessibilityLabel(viewModel.isGridView ? "Switch to list view" : "Switch to grid view")
            .padding(.leading, 12)
        }
        .padding(.horizontal, Spacing.screenHorizontal)
        .padding(.vertical, 4)
    }

    private var fileList: some View {
        VStack(spacing: 0) {
            searchBar
            filterChips
            folderScroll
            sortControl

            ScrollView {
                if viewModel.isGridView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 12)], spacing: 12) {
                        ForEach(viewModel.sortedFiles()) { file in
                            fileGridCell(file)
                        }
                    }
                    .padding(Spacing.screenHorizontal)
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.sortedFiles()) { file in
                            fileListRow(file)
                        }
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                }
            }
        }

        if viewModel.isSelectMode {
            bottomActionBar
        }
    }

    @State private var selectedFileURL: URL?

    private func fileGridCell(_ file: FileItem) -> some View {
        Button(action: {
            if viewModel.isSelectMode {
                if viewModel.selectedFiles.contains(file.id) {
                    viewModel.selectedFiles.remove(file.id)
                } else {
                    viewModel.selectedFiles.insert(file.id)
                }
            } else {
                selectedFileURL = file.url
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                FileIconView(fileType: file.fileType, size: 48)
                Text(file.name)
                    .bodyBoldStyle()
                    .foregroundColor(.labelPrimary)
                    .lineLimit(2)
                HStack {
                    FileTypeChip(fileType: file.fileType)
                    Spacer()
                    Text(file.formattedSize)
                        .microStyle()
                        .foregroundColor(.labelTertiary)
                }
            }
            .padding(10)
            .background(Color.surfaceCard)
            .cornerRadius(CornerRadius.card)
            .cardShadow()
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.card)
                    .stroke(viewModel.selectedFiles.contains(file.id) ? Color.inkBlue : Color.clear, lineWidth: 2)
            )
        }
    }

    private func fileListRow(_ file: FileItem) -> some View {
        HStack(spacing: 12) {
            FileIconView(fileType: file.fileType, size: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .bodyBoldStyle()
                    .foregroundColor(.labelPrimary)
                    .lineLimit(1)
                Text("\(file.formattedSize) · \(file.formattedDate)")
                    .captionStyle()
                    .foregroundColor(.labelTertiary)
            }

            Spacer()

            if viewModel.isSelectMode {
                Image(systemName: viewModel.selectedFiles.contains(file.id) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.selectedFiles.contains(file.id) ? .inkBlue : .labelQuaternary)
                    .font(.system(size: 20))
            }
        }
        .padding(10)
        .background(Color.surfaceCard)
        .cornerRadius(CornerRadius.card)
        .cardShadow()
        .contentShape(Rectangle())
        .onTapGesture {
            if viewModel.isSelectMode {
                if viewModel.selectedFiles.contains(file.id) {
                    viewModel.selectedFiles.remove(file.id)
                } else {
                    viewModel.selectedFiles.insert(file.id)
                }
            } else {
                selectedFileURL = file.url
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteFile(file)
                    } catch {
                        viewModel.errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                haptics.trigger(.press)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .tint(.inkBlue)
        }
    }

    private var bottomActionBar: some View {
        HStack(spacing: 20) {
            actionButton(icon: "square.and.arrow.up", label: "Share", disabled: viewModel.selectedFiles.isEmpty)
            actionButton(icon: "trash", label: "Delete", disabled: viewModel.selectedFiles.isEmpty, isDestructive: true)
            actionButton(icon: "arrow.up.doc", label: "Move", disabled: viewModel.selectedFiles.isEmpty)
            actionButton(icon: "doc.on.doc", label: "Duplicate", disabled: viewModel.selectedFiles.isEmpty)
            actionButton(icon: "archivebox", label: "Zip", disabled: viewModel.selectedFiles.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.surfaceCard)
        .shadow(color: .black.opacity(0.05), radius: 0, x: 0, y: -1)
    }

    private func actionButton(icon: String, label: String, disabled: Bool, isDestructive: Bool = false) -> some View {
        Button(action: {
            haptics.trigger(.press)
            if isDestructive {
                showDeleteConfirmation = true
            } else if label == "Share" {
                // Share selected files
            } else if label == "Move" {
                // Move to folder
            } else if label == "Duplicate" {
                // Duplicate files
            } else if label == "Zip" {
                // Archive files
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: IconSize.inline))
                Text(label)
                    .microStyle()
            }
            .foregroundColor(disabled ? .labelQuaternary : (isDestructive ? .destructiveRed : .inkBlue))
        }
        .disabled(disabled)
    }

    private var deleteConfirmationSheet: some View {
        VStack(spacing: 16) {
            Image(systemName: "trash")
                .font(.system(size: 40))
                .foregroundColor(.destructiveRed)
            Text("Delete \(viewModel.selectedFiles.count) file(s)?")
                .sectionHeaderStyle()
            Text("This action cannot be undone.")
                .bodyStyle()
                .foregroundColor(.labelSecondary)
            Button("Delete", role: .destructive) {
                viewModel.deleteSelected()
                showDeleteConfirmation = false
            }
            .buttonStyle(.borderedProminent)
            .tint(.destructiveRed)
        }
        .presentationDetents([.height(200)])
    }
}
