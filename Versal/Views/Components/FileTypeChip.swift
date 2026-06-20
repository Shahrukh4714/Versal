import SwiftUI

struct FileTypeChip: View {
    let fileType: FileType

    var body: some View {
        Text(fileType.rawValue)
            .microStyle()
            .foregroundColor(Color.fileIconColor(for: fileType))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.fileBackgroundColor(for: fileType))
            .cornerRadius(5)
    }
}
