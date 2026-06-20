import Foundation

enum FileType: String, Codable, CaseIterable {
    case pdf = "PDF"
    case docx = "DOCX"
    case jpg = "JPG"
    case png = "PNG"
    case mp4 = "MP4"
    case zip = "ZIP"
    case pptx = "PPTX"
    case xlsx = "XLSX"

    var fileExtension: String {
        rawValue.lowercased()
    }

    var utiType: String {
        switch self {
        case .pdf: return "com.adobe.pdf"
        case .docx: return "org.openxmlformats.wordprocessingml.document"
        case .jpg: return "public.jpeg"
        case .png: return "public.png"
        case .mp4: return "public.mpeg-4"
        case .zip: return "public.zip-archive"
        case .pptx: return "org.openxmlformats.presentationml.presentation"
        case .xlsx: return "org.openxmlformats.spreadsheetml.sheet"
        }
    }
}
