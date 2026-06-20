import SwiftUI

// MARK: - Text Styles

struct LargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.heavy))
    }
}

struct HeroHeadline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title.weight(.heavy))
            .lineSpacing(4)
    }
}

struct SectionHeaderText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
    }
}

struct BodyBoldText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline.weight(.semibold))
    }
}

struct BodyText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
    }
}

struct CaptionText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.weight(.medium))
    }
}

struct KickerText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.weight(.bold))
            .textCase(.uppercase)
            .kerning(1)
    }
}

struct MicroText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2.weight(.bold).monospacedDigit())
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
