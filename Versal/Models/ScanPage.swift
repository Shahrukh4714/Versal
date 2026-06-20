import Foundation
import UIKit

struct ScanPage: Identifiable {
    let id: UUID
    let image: UIImage
    let index: Int

    init(image: UIImage, index: Int) {
        self.id = UUID()
        self.image = image
        self.index = index
    }
}
