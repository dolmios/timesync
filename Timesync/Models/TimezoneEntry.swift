import Foundation

struct TimezoneEntry: Codable, Equatable, Hashable, Identifiable {
    let identifier: String
    let cityCode: String
    let displayName: String

    var id: String { identifier }

    var timezone: TimeZone? {
        TimeZone(identifier: identifier)
    }
}
