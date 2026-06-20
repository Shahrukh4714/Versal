import SwiftUI

struct ProLockBadge: View {
    var body: some View {
        Image(systemName: "lock.fill")
            .font(.system(size: 10))
            .foregroundColor(.labelQuaternary)
            .padding(4)
            .background(Color.backgroundGrouped)
            .clipShape(Circle())
    }
}
