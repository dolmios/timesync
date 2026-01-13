import Foundation

/// Utility class for parsing natural language date/time expressions
class DateParser {
    static let shared = DateParser()

    private var currentCalendar = Calendar.current
    private let formatter = DateFormatter()

    init() {
        formatter.locale = Locale(identifier: "en_US_POSIX")
    }

    /// Parse natural language input into a Date
    /// - Parameters:
    ///   - input: Natural language string (e.g., "thursday 5pm", "tomorrow 3pm", "feb 23 at 5pm")
    ///   - timezone: TimeZone to use for parsing
    /// - Returns: Parsed Date if successful, nil if parsing failed
    func parseDate(from input: String, in timezone: TimeZone) -> Date? {
        let input = input.trimmingCharacters(in: .whitespaces)
        guard !input.isEmpty else { return nil }

        formatter.timeZone = timezone

        // Update calendar to use the specified timezone
        var calendar = Calendar.current
        calendar.timeZone = timezone
        currentCalendar = calendar

        // Normalize input: remove ordinal suffixes and extra spaces
        let normalized = normalizeInput(input)
        let lowerInput = normalized.lowercased()

        // Try absolute date patterns first (highest priority - most specific)
        if let date = tryAbsoluteDateFormats(lowerInput) {
            return date
        }

        // Try relative date patterns (e.g., "next thursday", "tomorrow", "in 3 days")
        if let date = tryRelativeDatePatterns(lowerInput) {
            return date
        }

        return nil
    }

    private func normalizeInput(_ input: String) -> String {
        // Remove ordinal suffixes using regex
        var normalized = input
        normalized = normalized.replacingOccurrences(
            of: #"\b(\d+)(st|nd|rd|th)\b"#,
            with: "$1",
            options: .regularExpression
        )
        // Normalize multiple spaces to single space
        normalized = normalized.replacingOccurrences(
            of: #"\s+"#,
            with: " ",
            options: .regularExpression
        )
        return normalized
    }

    private func tryAbsoluteDateFormats(_ input: String) -> Date? {
        // Generate all combinations of date/time formats
        let dateFormats = [
            "MMM d", "MMMM d",           // Month+day
            "M/d/yyyy", "MM/dd/yyyy",   // Numeric dates
            "yyyy-MM-dd"                 // ISO format
        ]

        let timeFormats = [
            "h:mma", "ha",              // 12-hour with AM/PM
            "HH:mm", "H:mm",            // 24-hour formats
            ""                           // No time (optional)
        ]

        let separators = ["'at'", ""]   // With/without "at"

        for dateFormat in dateFormats {
            for timeSeparator in separators {
                for timeFormat in timeFormats {
                    let fullFormat: String
                    if timeFormat.isEmpty {
                        fullFormat = dateFormat
                    } else if timeSeparator.isEmpty {
                        fullFormat = "\(dateFormat) \(timeFormat)"
                    } else {
                        fullFormat = "\(dateFormat) \(timeSeparator) \(timeFormat)"
                    }

                    formatter.dateFormat = fullFormat
                    if let date = formatter.date(from: input) {
                        // If only time was parsed, use today's date
                        if dateFormat.isEmpty {
                            let timeComponents = currentCalendar.dateComponents([.hour, .minute], from: date)
                            let todayComponents = currentCalendar.dateComponents([.year, .month, .day], from: Date())
                            var combined = DateComponents()
                            combined.year = todayComponents.year
                            combined.month = todayComponents.month
                            combined.day = todayComponents.day
                            combined.hour = timeComponents.hour
                            combined.minute = timeComponents.minute
                            combined.second = 0
                            return currentCalendar.date(from: combined)
                        }

                        // If year wasn't provided (parsed as 2000), infer the correct year
                        let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
                        if dateComponents.year == 2000 {
                            return inferYearAndAdjust(month: dateComponents.month ?? 1,
                                                     day: dateComponents.day ?? 1,
                                                     date: date)
                        }

                        return date
                    }
                }
            }
        }

        return nil
    }

    private func inferYearAndAdjust(month: Int, day: Int, date: Date) -> Date {
        let nowComponents = currentCalendar.dateComponents([.year, .month, .day], from: Date())
        let currentYear = nowComponents.year ?? 2026
        let currentMonth = nowComponents.month ?? 1

        // Determine which year makes sense
        let year: Int
        if month > currentMonth {
            // User said a month further in the future (e.g., it's Jan, they said March)
            // → Assume current year
            year = currentYear
        } else if month < currentMonth {
            // User said a month that already passed (e.g., it's March, they said Jan)
            // → Assume next year
            year = currentYear + 1
        } else {
            // Same month - check the day
            if day >= (nowComponents.day ?? 1) {
                // Same month, same or future day → this month/year
                year = currentYear
            } else {
                // Same month, but day already passed → next year
                year = currentYear + 1
            }
        }

        var components = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = year
        return currentCalendar.date(from: components) ?? date
    }

    private func tryRelativeDatePatterns(_ input: String) -> Date? {
        var components = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        var dateWasSet = false

        // Try parsing patterns in order of priority
        if let result = tryInXDaysPattern(input, components: &components) {
            components = result
            dateWasSet = true
        }

        if !dateWasSet, let result = tryWeekdayPattern(input, components: &components) {
            components = result
            dateWasSet = true
        }

        if !dateWasSet, let result = tryTodayTomorrowPattern(input, components: &components) {
            components = result
            dateWasSet = true
        }

        // If no date pattern matched, don't proceed
        if !dateWasSet {
            return nil
        }

        // Parse and apply time
        applyTimeComponents(to: &components, from: input)

        return currentCalendar.date(from: components)
    }

    private func tryInXDaysPattern(_ input: String, components: inout DateComponents) -> DateComponents? {
        guard let inMatch = input.range(of: #"in\s+(\d+)\s+(days?|weeks?|hours?)"#, options: .regularExpression) else {
            return nil
        }

        let matchStr = String(input[inMatch]).lowercased()
        guard let number = Int(matchStr.filter { $0.isNumber }) else {
            return nil
        }

        var timeInterval: TimeInterval = 0
        if matchStr.contains("week") {
            timeInterval = TimeInterval(number * 7 * 24 * 3600)
        } else if matchStr.contains("day") {
            timeInterval = TimeInterval(number * 24 * 3600)
        } else if matchStr.contains("hour") {
            timeInterval = TimeInterval(number * 3600)
        }

        guard let newDate = currentCalendar.date(byAdding: .second, value: Int(timeInterval), to: Date()) else {
            return nil
        }

        return currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: newDate)
    }

    private func tryWeekdayPattern(_ input: String, components: inout DateComponents) -> DateComponents? {
        let weekdayMap = ["sunday": 1, "monday": 2, "tuesday": 3, "wednesday": 4,
                         "thursday": 5, "friday": 6, "saturday": 7]

        for (weekdayName, targetWeekday) in weekdayMap {
            guard input.contains(weekdayName) else { continue }

            let today = currentCalendar.component(.weekday, from: Date())
            let hasNextKeyword = input.contains("next")

            var daysToAdd: Int
            if targetWeekday > today {
                daysToAdd = targetWeekday - today
            } else if targetWeekday == today && !hasNextKeyword {
                daysToAdd = 7
            } else {
                daysToAdd = targetWeekday - today + 7
            }

            guard let date = currentCalendar.date(byAdding: .day, value: daysToAdd, to: Date()) else {
                continue
            }

            return currentCalendar.dateComponents([.year, .month, .day], from: date)
        }

        return nil
    }

    private func tryTodayTomorrowPattern(_ input: String, components: inout DateComponents) -> DateComponents? {
        if input.contains("today") {
            return currentCalendar.dateComponents([.year, .month, .day], from: Date())
        }

        if input.contains("tomorrow") {
            guard let tomorrow = currentCalendar.date(byAdding: .day, value: 1, to: Date()) else {
                return nil
            }
            return currentCalendar.dateComponents([.year, .month, .day], from: tomorrow)
        }

        return nil
    }

    private func applyTimeComponents(to components: inout DateComponents, from input: String) {
        let timeRegex = try? NSRegularExpression(
            pattern: #"(\d{1,2})(?::(\d{2}))?\s*(am|pm)?"#,
            options: .caseInsensitive
        )

        guard let regex = timeRegex,
              let match = regex.firstMatch(in: input, range: NSRange(input.startIndex..., in: input)) else {
            components.second = 0
            if components.hour == nil {
                components.hour = currentCalendar.component(.hour, from: Date())
                components.minute = currentCalendar.component(.minute, from: Date())
            }
            return
        }

        let hourStr = (input as NSString).substring(with: match.range(at: 1))
        let minuteStr = match.range(at: 2).location != NSNotFound ?
            (input as NSString).substring(with: match.range(at: 2)) : "0"
        let ampmStr = match.range(at: 3).location != NSNotFound ?
            (input as NSString).substring(with: match.range(at: 3)).lowercased() : nil

        guard let hour = Int(hourStr), let minute = Int(minuteStr) else {
            components.second = 0
            if components.hour == nil {
                components.hour = currentCalendar.component(.hour, from: Date())
                components.minute = currentCalendar.component(.minute, from: Date())
            }
            return
        }

        var hour24 = hour
        if let ampm = ampmStr {
            if ampm == "pm" && hour != 12 {
                hour24 = hour + 12
            } else if ampm == "am" && hour == 12 {
                hour24 = 0
            }
        } else if hour > 12 {
            hour24 = hour
        }

        components.hour = hour24
        components.minute = minute
        components.second = 0
    }
}
