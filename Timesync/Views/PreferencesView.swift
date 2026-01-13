import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var preferences: AppPreferences

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Time Format")
                        .font(StandardFont.body)
                        .foregroundColor(.primary)
                    CheckboxButton("Use 24-hour time", isChecked: $preferences.use24HourTime)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Startup")
                        .font(StandardFont.body)
                        .foregroundColor(.primary)
                    CheckboxButton("Launch on login", isChecked: $preferences.launchOnLogin)
                }

                Spacer()
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            VStack(spacing: 4) {
                Text("© \(currentYear) Jackson Dolman - dolmios.com")
                    .font(StandardFont.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
    }

    private var currentYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }
}

struct CheckboxButton: View {
    let label: String
    @Binding var isChecked: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false

    init(_ label: String, isChecked: Binding<Bool>) {
        self.label = label
        self._isChecked = isChecked
    }

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack(spacing: 10) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isChecked ? Color(hex: "e8a519") : .secondary)
                Text(label)
                    .font(StandardFont.body)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                isHovered
                    ? Color.primary.opacity(colorScheme == .dark ? 0.05 : 0.03)
                    : Color.clear
            )
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
