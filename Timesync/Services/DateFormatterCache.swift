import Foundation

/// Cached DateFormatter instances for performance
enum DateFormatterCache {
    private static let formatters = ThreadSafeDictionary<String, DateFormatter>()

    static func formatter(format: String, timeZone: TimeZone, locale: Locale = .current) -> DateFormatter {
        let key = "\(format)_\(timeZone.identifier)_\(locale.identifier)"

        if let cached = formatters[key] {
            return cached
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatters[key] = formatter

        return formatter
    }
}

/// Thread-safe dictionary for caching formatters
private class ThreadSafeDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.timesync.formattercache", attributes: .concurrent)

    subscript(key: Key) -> Value? {
        get {
            queue.sync { dictionary[key] }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?.dictionary[key] = newValue
            }
        }
    }
}
