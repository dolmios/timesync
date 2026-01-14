import SwiftUI

extension TimeZone {
    func dstAbbreviation(for date: Date) -> String? {
        let abbreviation = abbreviation(for: date) ?? ""
        return abbreviation.count >= 3 ? abbreviation : nil
    }
}

struct ConverterView: View {
    @EnvironmentObject var timezoneSelection: TimezoneSelection
    @EnvironmentObject var preferences: AppPreferences
    @State private var naturalLanguageInput = ""
    @State private var sourceTimezone: TimezoneEntry?
    @State private var conversionResults: [ConversionResult] = []

    var body: some View {
        VStack(spacing: 0) {
            // From selector - top
            HStack(spacing: 12) {
                Text("From:")
                    .font(StandardFont.body)
                    .foregroundColor(.secondary)
                Spacer()
                Menu {
                    ForEach(timezoneSelection.selectedTimezones) { timezone in
                        Button {
                            sourceTimezone = timezone
                        } label: {
                            HStack {
                                Text(timezone.displayName)
                                if sourceTimezone?.identifier == timezone.identifier {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(sourceTimezone?.displayName ?? "Current Timezone")
                            .font(StandardFont.body)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.primary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(4)
                }
            }
            .padding(12)

            Divider()

            // Input - center
            Spacer()
            ZStack {
                TextField("e.g., Thursday at 5pm", text: $naturalLanguageInput)
                    .font(StandardFont.body)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        performNaturalLanguageConversion()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .modifier(InputHoverEffect())
            Spacer()

            // Results
            if !conversionResults.isEmpty {
                Divider()
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(conversionResults) { result in
                            ConversionResultRow(result: result)
                        }
                    }
                }
            }

            Divider()

            // Convert button - bottom
            PrimaryButton("Convert", icon: "arrow.left.arrow.right") {
                performNaturalLanguageConversion()
            }
            .frame(maxWidth: .infinity)
            .padding(12)
        }
        .onAppear {
            let currentTZ = TimeZone.current.identifier
            sourceTimezone = timezoneSelection.selectedTimezones.first {
                $0.identifier == currentTZ
            }
        }
        .onChange(of: timezoneSelection.selectedTimezones) { _, newValue in
            // If the source timezone is no longer in the selected list, reset to current
            if let source = sourceTimezone, !newValue.contains(source) {
                let currentTZ = TimeZone.current.identifier
                sourceTimezone = newValue.first { $0.identifier == currentTZ }
            }
        }
    }

    private func performNaturalLanguageConversion() {
        guard !naturalLanguageInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            conversionResults = []
            return
        }

        let sourceTZ = sourceTimezone?.timezone ?? TimeZone.current
        let parsedDate = DateParser.shared.parseDate(from: naturalLanguageInput, in: sourceTZ)

        guard let date = parsedDate else {
            conversionResults = []
            return
        }

        let results = convertDateToTimezones(date: date, sourceTimeZone: sourceTZ)
        conversionResults = sortResultsByOffset(results, sourceOffset: sourceTZ.secondsFromGMT())
    }

    private func convertDateToTimezones(date: Date, sourceTimeZone: TimeZone) -> [ConversionResult] {
        return timezoneSelection.selectedTimezones.compactMap { timezoneInfo -> ConversionResult? in
            guard let timeZone = timezoneInfo.timezone else { return nil }
            return createConversionResult(
                date: date,
                timezoneInfo: timezoneInfo,
                timeZone: timeZone
            )
        }
    }

    private func createConversionResult(
        date: Date,
        timezoneInfo: TimezoneEntry,
        timeZone: TimeZone
    ) -> ConversionResult {
        let format = preferences.use24HourTime ? "HH:mm" : "h:mma"
        let timeFormatter = DateFormatterCache.formatter(format: format, timeZone: timeZone)
        let dateFormatter = DateFormatterCache.formatter(format: "MMM d, yyyy", timeZone: timeZone)
        let weekdayFormatter = DateFormatterCache.formatter(format: "EEE", timeZone: timeZone)

        let time = timeFormatter.string(from: date)
        let formattedTime = !preferences.use24HourTime && time.hasSuffix("m")
            ? time.replacingOccurrences(of: "am", with: "AM")
                .replacingOccurrences(of: "pm", with: "PM")
            : time

        let dateStr = dateFormatter.string(from: date)
        let weekday = weekdayFormatter.string(from: date).uppercased()
        let dstAbbreviation = timeZone.dstAbbreviation(for: date) ?? ""

        return ConversionResult(
            timezone: timezoneInfo,
            time: formattedTime,
            date: dateStr,
            weekday: weekday,
            dstAbbreviation: dstAbbreviation
        )
    }

    private func sortResultsByOffset(
        _ results: [ConversionResult],
        sourceOffset: Int
    ) -> [ConversionResult] {
        return results.sorted { itemA, itemB in
            guard let tzA = itemA.timezone.timezone, let tzB = itemB.timezone.timezone else {
                return false
            }
            let offsetA = abs(tzA.secondsFromGMT() - sourceOffset)
            let offsetB = abs(tzB.secondsFromGMT() - sourceOffset)
            return offsetA < offsetB
        }
    }
}

struct ConversionResultRow: View {
    let result: ConversionResult

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(result.timezone.cityCode)
                        .font(StandardFont.body)
                        .foregroundColor(.primary)
                    if !result.dstAbbreviation.isEmpty {
                        Text(result.dstAbbreviation)
                            .font(StandardFont.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(result.time)
                    .font(StandardFont.body)
                    .foregroundColor(.primary)
                Text("\(result.weekday) \(result.date)")
                    .font(StandardFont.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

struct InputHoverEffect: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .shadow(
                color: isHovered
                    ? Color.primary.opacity(colorScheme == .dark ? 0.2 : 0.1)
                    : Color.clear,
                radius: isHovered ? 8 : 0,
                x: 0,
                y: isHovered ? -2 : 0
            )
            .scaleEffect(isHovered ? 1.02 : 1.0, anchor: .center)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}
