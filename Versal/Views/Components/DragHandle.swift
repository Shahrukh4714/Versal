import SwiftUI

struct DragHandle: View {
    var body: some View {
        Capsule()
            .fill(Color(red: 0xD1 / 255, green: 0xD1 / 255, blue: 0xD6 / 255))
            .frame(width: 36, height: 4)
            .padding(.top, 8)
    }
}
