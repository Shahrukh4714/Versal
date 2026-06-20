import SwiftUI

// MARK: - Text Styles

struct LargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 28, weight: .heavy, design: .default))
    }
}

struct HeroHeadline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .heavy, design: .default))
            .lineSpacing(24 * 0.2)
    }
}

struct SectionHeaderText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .bold, design: .default))
    }
}

struct BodyBoldText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .semibold, design: .default))
    }
}

struct BodyText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .regular, design: .default))
    }
}

struct CaptionText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .medium, design: .default))
    }
}

struct KickerText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 11.5, weight: .bold, design: .default))
            .textCase(.uppercase)
            .kerning(0.08 * 11.5)
    }
}

struct MicroText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 10, weight: .bold, design: .monospaced))
    }
}

extension View {
    func largeTitleStyle() -> some View { modifier(LargeTitle()) }
    func heroHeadlineStyle() -> some View { modifier(HeroHeadline()) }
    func sectionHeaderStyle() -> some View { modifier(SectionHeaderText()) }
    func bodyBoldStyle() -> some View { modifier(BodyBoldText()) }
    func bodyStyle() -> some View { modifier(BodyText()) }
    func captionStyle() -> some View { modifier(CaptionText()) }
    func kickerStyle() -> some View { modifier(KickerText()) }
    func microStyle() -> some View { modifier(MicroText()) }
}
