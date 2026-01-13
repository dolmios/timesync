import AppKit
import SwiftUI

/// Helper for Standard font usage throughout the app
struct StandardFont {
    /// Book weight (regular) with fallback
    static func book(size: CGFloat) -> Font {
        if let font = NSFont(name: "Standard", size: size) {
            return Font(font)
        }
        return .system(size: size)
    }

    /// Bold weight with fallback
    static func bold(size: CGFloat) -> Font {
        if let font = NSFont(name: "Standard-Bold", size: size) {
            return Font(font)
        }
        return .system(size: size, weight: .bold)
    }

    /// Book italic weight with fallback
    static func bookItalic(size: CGFloat) -> Font {
        if let font = NSFont(name: "Standard-BookItalic", size: size) {
            return Font(font)
        }
        return .system(size: size, design: .default).italic()
    }

    /// Bold italic weight with fallback
    static func boldItalic(size: CGFloat) -> Font {
        if let font = NSFont(name: "Standard-BoldItalic", size: size) {
            return Font(font)
        }
        return .system(size: size, weight: .bold).italic()
    }
}

// MARK: - Semantic Font Sizes

extension StandardFont {
    static let heading1 = book(size: 28)
    static let heading2 = book(size: 24)
    static let heading3 = book(size: 20)
    static let body = book(size: 14)
    static let caption = book(size: 12)
    static let button = bold(size: 13)
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            let redValue = (int >> 8) * 17
            let greenValue = (int >> 4 & 0xF) * 17
            let blueValue = (int & 0xF) * 17
            (alpha, red, green, blue) = (255, redValue, greenValue, blueValue)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
