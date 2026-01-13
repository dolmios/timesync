import Combine
import Foundation
import OSLog

extension Logger {
    static let timezoneSelection = Logger(
        subsystem: "com.dolmios.timesync",
        category: "TimezoneSelection"
    )
}

class TimezoneSelection: ObservableObject {
    @Published var pinnedTimezone: TimezoneEntry
    @Published var selectedTimezones: [TimezoneEntry]

    private let userDefaults = UserDefaults.standard
    private let pinnedKey = "pinnedTimezone"
    private let selectedKey = "selectedTimezones"
    private let logger = Logger(subsystem: "com.timesync", category: "TimezoneSelection")

    private static let defaultNYC = TimezoneEntry(
        identifier: "America/New_York",
        cityCode: "NYC",
        displayName: "New York"
    )
    private static let defaultMelbourne = TimezoneEntry(
        identifier: "Australia/Melbourne",
        cityCode: "MEL",
        displayName: "Melbourne"
    )

    init() {
        let currentTZ = TimeZone.current.identifier

        self.selectedTimezones = currentTZ == "America/New_York"
            ? [Self.defaultNYC, Self.defaultMelbourne]
            : [Self.createCurrentTimezoneInfo(), Self.defaultMelbourne]
        self.pinnedTimezone = Self.defaultMelbourne

        loadFromDefaults()
    }

    private static func createCurrentTimezoneInfo() -> TimezoneEntry {
        let currentTZ = TimeZone.current.identifier
        let parts = currentTZ.split(separator: "/")
        let cityCode = String(parts.last?.prefix(3).uppercased() ?? "LOC")
        let displayName = parts.last?.replacingOccurrences(of: "_", with: " ") ?? "Current"

        return TimezoneEntry(
            identifier: currentTZ,
            cityCode: cityCode,
            displayName: displayName
        )
    }

    private func loadFromDefaults() {
        loadPinnedTimezone()
        loadSelectedTimezones()
    }

    private func loadPinnedTimezone() {
        guard let pinnedData = userDefaults.data(forKey: pinnedKey) else { return }
        do {
            let pinned = try JSONDecoder().decode(TimezoneEntry.self, from: pinnedData)
            // Validate timezone identifier
            if let timezone = TimeZone(identifier: pinned.identifier),
               TimeZone.knownTimeZoneIdentifiers.contains(pinned.identifier) {
                pinnedTimezone = pinned
            } else {
                logger.warning(
                    "Invalid or unknown timezone identifier in pinned timezone: \(pinned.identifier)"
                )
                pinnedTimezone = Self.defaultMelbourne
            }
        } catch {
            logger.error("Failed to decode pinned timezone: \(error.localizedDescription)")
            pinnedTimezone = Self.defaultMelbourne
        }
    }

    private func loadSelectedTimezones() {
        guard let selectedData = userDefaults.data(forKey: selectedKey) else { return }
        do {
            let selected = try JSONDecoder().decode([TimezoneEntry].self, from: selectedData)
            guard !selected.isEmpty else { return }
            let validTimezones = selected.filter { timezoneInfo in
                TimeZone.knownTimeZoneIdentifiers.contains(timezoneInfo.identifier) &&
                TimeZone(identifier: timezoneInfo.identifier) != nil
            }
            if !validTimezones.isEmpty {
                selectedTimezones = validTimezones
                if validTimezones.count < selected.count {
                    logger.info(
                        "Filtered out \(selected.count - validTimezones.count) invalid timezone(s)"
                    )
                }
            } else {
                logger.warning(
                    "No valid timezones found in saved data, resetting to defaults"
                )
                resetToDefaultTimezones()
            }
        } catch {
            logger.error("Failed to decode selected timezones: \(error.localizedDescription)")
            resetToDefaultTimezones()
        }
    }

    private func resetToDefaultTimezones() {
        let currentTZ = TimeZone.current.identifier
        selectedTimezones = currentTZ == "America/New_York"
            ? [Self.defaultNYC, Self.defaultMelbourne]
            : [Self.createCurrentTimezoneInfo(), Self.defaultMelbourne]
    }

    func saveToDefaults() {
        do {
            let pinnedData = try JSONEncoder().encode(pinnedTimezone)
            userDefaults.set(pinnedData, forKey: pinnedKey)
        } catch {
            logger.error("Failed to encode pinned timezone: \(error.localizedDescription)")
        }

        do {
            let selectedData = try JSONEncoder().encode(selectedTimezones)
            userDefaults.set(selectedData, forKey: selectedKey)
        } catch {
            logger.error("Failed to encode selected timezones: \(error.localizedDescription)")
        }
    }

    func pinTimezone(_ timezone: TimezoneEntry) {
        // Prevent pinning current timezone
        guard timezone.identifier != TimeZone.current.identifier else { return }
        pinnedTimezone = timezone
        saveToDefaults()
    }

    func addTimezone(_ timezone: TimezoneEntry) {
        // Validate timezone exists before adding
        guard timezone.timezone != nil else { return }

        // Check for duplicates
        guard !selectedTimezones.contains(where: { $0.identifier == timezone.identifier }) else {
            return
        }

        selectedTimezones.append(timezone)
        saveToDefaults()
    }

    func removeTimezone(_ timezone: TimezoneEntry) {
        // Prevent removing the last timezone
        guard selectedTimezones.count > 1 else { return }

        selectedTimezones.removeAll { $0.identifier == timezone.identifier }

        // If we removed the pinned timezone, pin the first remaining one
        if pinnedTimezone.identifier == timezone.identifier && !selectedTimezones.isEmpty {
            pinnedTimezone = selectedTimezones[0]
        }

        saveToDefaults()
    }
}
