import SwiftUI

// MARK: - Design Tokens (Palette A — "Volt")

enum FH {

    // MARK: Colors

    enum Colors {
        // Backgrounds
        static let bg = Color(hex: 0x0B0D10)
        static let surface = Color(hex: 0x14181D)
        static let surface2 = Color(hex: 0x1C2128)
        static let border = Color(hex: 0x262C34)

        // Text
        static let text = Color(hex: 0xF4F6F8)
        static let textMuted = Color(hex: 0x9BA4AE)
        static let textSubtle = Color(hex: 0x5E6671)

        // Brand
        static let primary = Color(hex: 0xC6FF3D)
        static let primaryInk = Color(hex: 0x0B0D10)
        static let accent = Color(hex: 0x5B8CFF)

        // Semantic
        static let success = Color(hex: 0x22C55E)
        static let warning = Color(hex: 0xF5B83D)
        static let danger = Color(hex: 0xFF5C5C)

        // Gradients
        static let primaryGradient = LinearGradient(
            colors: [Color(hex: 0xC6FF3D), Color(hex: 0xA8E025)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let surfaceGradient = LinearGradient(
            colors: [Color(hex: 0x14181D), Color(hex: 0x0B0D10)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let base: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
        static let huge: CGFloat = 56
    }

    // MARK: Radius

    enum Radius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 10
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let pill: CGFloat = 999
    }
}

// MARK: - Color Hex Init

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}

// MARK: - View Modifiers

struct FHCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(FH.Spacing.base)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
    }
}

struct FHPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(FH.Colors.primaryInk)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(FH.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct FHSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(FH.Colors.text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(FH.Colors.surface2)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension View {
    func fhCard() -> some View {
        modifier(FHCardModifier())
    }
}
