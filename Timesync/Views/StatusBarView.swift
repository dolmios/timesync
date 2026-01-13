import SwiftUI

struct StatusBarView: View {
    @EnvironmentObject var timezoneSelection: TimezoneSelection
    @EnvironmentObject var statusBarClock: StatusBarClock
    @EnvironmentObject var preferences: AppPreferences

    var body: some View {
        HStack(spacing: 2) {
            Text(formatStatusBarDisplay())
                .font(.system(size: AppConstants.menuBarFontSize, weight: .medium))
        }
    }

    private func formatStatusBarDisplay() -> String {
        let timezone = timezoneSelection.pinnedTimezone.timezone ?? TimeZone.current

        let format = preferences.use24HourTime ? "HH:mm" : "h:mm a"
        let timeFormatter = DateFormatterCache.formatter(format: format, timeZone: timezone)
        let weekdayFormatter = DateFormatterCache.formatter(format: "EEE", timeZone: timezone)

        let time = timeFormatter.string(from: statusBarClock.currentDate)
        let weekday = weekdayFormatter.string(from: statusBarClock.currentDate).uppercased()

        return "\(timezoneSelection.pinnedTimezone.cityCode) \(time) (\(weekday))"
    }
}
