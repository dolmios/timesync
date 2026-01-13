import SwiftUI

struct TimezonesView: View {
    @EnvironmentObject var timezoneSelection: TimezoneSelection
    @EnvironmentObject var preferences: AppPreferences
    @State private var showingTimezonePicker = false

    var currentTimezone: TimezoneEntry? {
        let currentTZ = TimeZone.current.identifier
        return timezoneSelection.selectedTimezones.first { $0.identifier == currentTZ }
    }

    var sortedTimezones: [TimezoneEntry] {
        var timezones = timezoneSelection.selectedTimezones
        // Sort: current first, then pinned, then others
        timezones.sort { tz1, tz2 in
            let tz1IsCurrent = tz1.identifier == TimeZone.current.identifier
            let tz2IsCurrent = tz2.identifier == TimeZone.current.identifier
            let tz1IsPinned = tz1.identifier == timezoneSelection.pinnedTimezone.identifier
            let tz2IsPinned = tz2.identifier == timezoneSelection.pinnedTimezone.identifier

            if tz1IsCurrent && !tz2IsCurrent { return true }
            if !tz1IsCurrent && tz2IsCurrent { return false }
            if tz1IsPinned && !tz2IsPinned { return true }
            if !tz1IsPinned && tz2IsPinned { return false }
            return tz1.displayName < tz2.displayName
        }
        return timezones
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sortedTimezones) { timezone in
                        TimezonesRow(
                            timezone: timezone,
                            isPinned: timezone.identifier ==
                                timezoneSelection.pinnedTimezone.identifier,
                            isCurrent: timezone.identifier == TimeZone.current.identifier
                        )
                        .environmentObject(timezoneSelection)
                        .environmentObject(preferences)
                    }
                }
            }

            Divider()

            PrimaryButton("Add Timezone", icon: "plus.circle") {
                showingTimezonePicker = true
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .popover(isPresented: $showingTimezonePicker, arrowEdge: .bottom) {
                TimezoneSelectionPickerView()
            }
        }
    }
}
