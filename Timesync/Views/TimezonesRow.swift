import SwiftUI

struct TimezonesRow: View {
    let timezone: TimezoneEntry
    let isPinned: Bool
    let isCurrent: Bool
    @EnvironmentObject var timezoneSelection: TimezoneSelection
    @EnvironmentObject var preferences: AppPreferences
    @Environment(\.colorScheme) var colorScheme
    private let clockService = ClockService.shared
    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(alignment: .top, spacing: 6) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(timezone.cityCode)
                            .font(StandardFont.body)
                            .foregroundColor(.primary)
                        if let dstAbbr = dstAbbreviation, !dstAbbr.isEmpty {
                            Text(dstAbbr)
                                .font(StandardFont.body)
                                .foregroundColor(.secondary)
                        }
                        if isCurrent {
                            Text("Local")
                                .font(StandardFont.caption)
                                .foregroundColor(Color(hex: "e8a519"))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "e8a519").opacity(0.15))
                                .cornerRadius(4)
                        }
                        if isPinned {
                            Text("Pinned")
                                .font(StandardFont.caption)
                                .foregroundColor(Color(hex: "e8a519"))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "e8a519").opacity(0.15))
                                .cornerRadius(4)
                        }
                    }

                    HStack(spacing: 6) {
                        Text(formattedTime)
                            .font(StandardFont.body)
                            .foregroundColor(.primary)
                        Text("\(formattedWeekday) \(formattedDate)")
                            .font(StandardFont.body)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    if !isPinned && !isCurrent {
                        Button("Display in Menu Bar") {
                            timezoneSelection.pinTimezone(timezone)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .font(StandardFont.body)
                    }

                    Button {
                        timezoneSelection.removeTimezone(timezone)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                isHovered
                    ? Color.primary.opacity(colorScheme == .dark ? 0.05 : 0.03)
                    : Color.clear
            )
            .cornerRadius(6)
        }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private var formattedTime: String {
        guard let timeZone = timezone.timezone else { return "" }
        let format = preferences.use24HourTime ? "HH:mm" : "h:mma"
        let formatter = DateFormatterCache.formatter(format: format, timeZone: timeZone)
        return formatter.string(from: clockService.currentDate)
    }

    private var formattedDate: String {
        guard let timeZone = timezone.timezone else { return "" }
        let formatter = DateFormatterCache.formatter(format: "MMM d", timeZone: timeZone)
        return formatter.string(from: clockService.currentDate)
    }

    private var formattedWeekday: String {
        guard let timeZone = timezone.timezone else { return "" }
        let formatter = DateFormatterCache.formatter(format: "EEE", timeZone: timeZone)
        return formatter.string(from: clockService.currentDate).uppercased()
    }

    private var dstAbbreviation: String? {
        guard let timeZone = timezone.timezone else { return nil }
        let abbreviation = timeZone.abbreviation(for: clockService.currentDate) ?? ""
        return abbreviation.count >= 3 ? abbreviation : nil
    }
}
