import Foundation
import SwiftUI

/// Application-wide constants
enum AppConstants {
    // Timer
    static let timerInterval: TimeInterval = 1.0

    // UI Dimensions
    static let menuBarWindowWidth: CGFloat = 280
    static let menuBarWindowHeight: CGFloat = 500
    static let timezonePickerWidth: CGFloat = 400
    static let timezonePickerHeight: CGFloat = 500

    // Typography System
    // Minimalist design: All text uses 13pt base size, differentiated by weight and opacity only
    static let baseFontSize: CGFloat = 13
    static let menuBarFontSize: CGFloat = 11
}
