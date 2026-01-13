import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?  // SF Symbol name (e.g., "plus.circle", "clock")
    let action: () -> Void
    var isEnabled: Bool = true
    var spacing: CGFloat = 8
    @State private var isHovered = false

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: spacing) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .semibold))
                        .frame(width: 14, height: 14)
                }
                Text(title)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PrimaryButtonStyle(isHovered: isHovered))
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - PrimaryButtonStyle
struct PrimaryButtonStyle: ButtonStyle {
    var isHovered: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(StandardFont.body)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color(hex: "e8a519"))
            .cornerRadius(6)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .brightness(isHovered && !configuration.isPressed ? 0.1 : 0)
    }
}
