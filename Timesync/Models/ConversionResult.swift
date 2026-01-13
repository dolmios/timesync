import Foundation

struct ConversionResult: Identifiable {
    let id = UUID()
    let timezone: TimezoneEntry
    let time: String
    let date: String
    let weekday: String
    let dstAbbreviation: String
}
