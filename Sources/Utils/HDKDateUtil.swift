import Foundation

@objcMembers
public class HDKDateUtil: NSObject {

    // MARK: - Formatters

    public static func standardFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = sharedGMTTimeZone
        formatter.locale = Locale.current
        formatter.calendar = sharedCalendar
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    public static let sharedServerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = sharedGMTTimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = sharedENUSPOSIXLocale
        formatter.calendar = gregorianCalendar()
        return formatter
    }()

    public static let sharedGMTTimeZone: TimeZone = TimeZone(abbreviation: "GMT")!

    public static let sharedENUSPOSIXLocale: Locale = Locale(identifier: "en_US_POSIX")

    public static let sharedCalendar: Calendar = {
        var gregorian = gregorianCalendar()
        gregorian.locale = Locale.current
        return gregorian
    }()

    public static func gregorianCalendar() -> Calendar {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = sharedGMTTimeZone
        return calendar
    }

    private static let serverTimeFormatter: DateFormatter = {
        let formatter = standardFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    // MARK: -

    public static func isDate(_ firstDate: Date, beforeDate lastDate: Date) -> Bool {
        return lastDate.timeIntervalSince(firstDate) > 0
    }

    public static func time(fromString timeString: String) -> Date? {
        return serverTimeFormatter.date(from: timeString)
    }

    // MARK: - Seasons

    public static func seasonDate(_ string: String) -> Date? {
        return dateFromServerString(string)
    }

    public static func isDate(_ date: Date, between start: Date, and end: Date) -> Bool {
        return isDate(start, beforeDate: date) && isDate(date, beforeDate: end)
    }

    // MARK: - Default Dates Formatting

    public static func dateFromServerString(_ string: String) -> Date? {
        return sharedServerDateFormatter.date(from: string)
    }

    public static func serverStringFromDate(_ date: Date) -> String {
        return sharedServerDateFormatter.string(from: date)
    }

}
