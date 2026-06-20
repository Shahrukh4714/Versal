import SwiftUI

struct FileIconView: View {
    let fileType: FileType
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.smallIconContainer)
                .fill(Color.fileBackgroundColor(for: fileType))
                .frame(width: size, height: size)

            Image(systemName: systemImageName)
                .font(.system(size: size * 0.45))
                .foregroundColor(Color.fileIconColor(for: fileType))
        }
    }

    private var systemImageName: String {
        switch fileType {
        case .pdf: return "doc.richtext"
        case .docx: return "doc.text"
        case .jpg, .png: return "photo"
        case .mp4: return "video"
        case .zip: return "archivebox"
        case .pptx: return "chart.bar.doc.horizontal"
        case .xlsx: return "tablecells"
        }
    }
}
