import SwiftUI

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showReview {
                    reviewScreen
                } else {
                    cameraPlaceholder
                }
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
    }

    private var cameraPlaceholder: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.card)
                    .stroke(Color.inkWash, lineWidth: 2)
                    .frame(width: 280, height: 360)

                Image(systemName: "document.viewfinder")
                    .font(.system(size: 60))
                    .foregroundColor(.inkWash.opacity(0.6))
            }

            Text("Position document in frame")
                .bodyStyle()
                .foregroundColor(.white)

            Spacer()

            Button(action: { viewModel.startScan() }) {
                Circle()
                    .fill(Color.inkBlue)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    )
            }
            .accessibilityLabel("Capture document")
            .padding(.bottom, 40)
        }
    }

    private var reviewScreen: some View {
        VStack(spacing: 0) {
            if let image = viewModel.scannedPages.last?.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }

            Spacer()

            VStack(spacing: 12) {
                DragHandle()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(ScannerViewModel.ScanFilter.allCases, id: \.rawValue) { filter in
                            Text(filter.rawValue)
                                .captionStyle()
                                .foregroundColor(viewModel.selectedFilter == filter ? .white : .inkBlue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedFilter == filter ? Color.inkBlue : Color.inkWash)
                                .cornerRadius(14)
                                .onTapGesture { viewModel.applyFilter(filter) }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                HStack(spacing: 16) {
                    Button(action: { viewModel.retake() }) {
                        Text("Retake")
                            .bodyBoldStyle()
                            .foregroundColor(.inkBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.inkWash)
                            .cornerRadius(CornerRadius.button)
                    }

                    Button(action: { viewModel.saveScan() }) {
                        Text("Save & Export")
                            .bodyBoldStyle()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.inkBlue)
                            .cornerRadius(CornerRadius.button)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.55)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .background(Color.surfaceCard)
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .background(Color.black)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
