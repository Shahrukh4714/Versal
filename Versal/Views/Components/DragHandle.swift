import SwiftUI

struct DragHandle: View {
    var body: some View {
        Capsule()
            .fill(Color.labelQuaternary)
            .frame(width: 36, height: 4)
            .padding(.top, 8)
    }
}
