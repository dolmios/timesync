import AppKit
import SwiftUI

struct WindowContentView: View {
    @EnvironmentObject var timezoneSelection: TimezoneSelection
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                TabOption(icon: "globe", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabOption(icon: "arrow.left.arrow.right", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabOption(icon: "gear", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(8)
            .background(
                colorScheme == .dark ? Color(hex: "1a1a1a") : Color(NSColor.controlBackgroundColor)
            )

            Divider()

            Group {
                if selectedTab == 0 {
                    TimezonesView()
                } else if selectedTab == 1 {
                    ConverterView()
                } else {
                    PreferencesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                colorScheme == .dark ? Color(hex: "1a1a1a") : Color(NSColor.windowBackgroundColor)
            )
        }
        .frame(width: AppConstants.menuBarWindowWidth, height: AppConstants.menuBarWindowHeight)
        .background(.ultraThinMaterial)
    }
}

struct TabOption: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(
                    isSelected
                        ? (colorScheme == .dark ? Color(hex: "1a1a1a") : .white)
                        : .primary
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    isSelected
                        ? (colorScheme == .dark ? Color.white : Color(hex: "1a1a1a"))
                        : (isHovered
                            ? Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.05)
                            : Color.clear)
                )
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
