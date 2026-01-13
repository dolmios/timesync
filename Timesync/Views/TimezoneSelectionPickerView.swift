import SwiftUI

private struct CommonTimezone {
    let identifier: String
    let code: String
    let name: String
}

struct TimezoneSelectionPickerView: View {
    @EnvironmentObject var timezoneSelection: TimezoneSelection
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    let commonTimezones: [CommonTimezone] = [
        CommonTimezone(identifier: "America/New_York", code: "NYC", name: "New York"),
        CommonTimezone(identifier: "America/Los_Angeles", code: "SFO", name: "San Francisco"),
        CommonTimezone(identifier: "America/Chicago", code: "CHI", name: "Chicago"),
        CommonTimezone(identifier: "Europe/London", code: "LON", name: "London"),
        CommonTimezone(identifier: "Europe/Paris", code: "PAR", name: "Paris"),
        CommonTimezone(identifier: "Asia/Tokyo", code: "TYO", name: "Tokyo"),
        CommonTimezone(identifier: "Asia/Shanghai", code: "SHA", name: "Shanghai"),
        CommonTimezone(identifier: "Asia/Dubai", code: "DXB", name: "Dubai"),
        CommonTimezone(identifier: "Australia/Sydney", code: "SYD", name: "Sydney"),
        CommonTimezone(identifier: "Australia/Melbourne", code: "MEL", name: "Melbourne"),
        CommonTimezone(identifier: "Pacific/Auckland", code: "AKL", name: "Auckland"),
        CommonTimezone(identifier: "America/Toronto", code: "TOR", name: "Toronto"),
        CommonTimezone(identifier: "America/Vancouver", code: "VAN", name: "Vancouver"),
        CommonTimezone(identifier: "Europe/Berlin", code: "BER", name: "Berlin"),
        CommonTimezone(identifier: "Europe/Madrid", code: "MAD", name: "Madrid")
    ]

    var filteredTimezones: [CommonTimezone] {
        if searchText.isEmpty {
            return commonTimezones
        }
        return commonTimezones.filter { timezone in
            timezone.code.localizedCaseInsensitiveContains(searchText) ||
            timezone.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Search timezones", text: $searchText)
                .font(StandardFont.body)
                .textFieldStyle(.roundedBorder)
                .focused($isSearchFocused)
                .padding()
                .onAppear {
                    isSearchFocused = true
                }

            List(filteredTimezones, id: \.identifier) { timezone in
                Button {
                    let entry = TimezoneEntry(
                        identifier: timezone.identifier,
                        cityCode: timezone.code,
                        displayName: timezone.name
                    )
                    timezoneSelection.addTimezone(entry)
                    dismiss()
                } label: {
                    HStack {
                        Text(timezone.code)
                            .font(StandardFont.body)
                        Text(timezone.name)
                            .font(StandardFont.body)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: AppConstants.timezonePickerWidth, height: AppConstants.timezonePickerHeight)
    }
}
