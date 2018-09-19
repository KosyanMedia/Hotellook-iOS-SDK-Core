@objcMembers
public final class HDKSeason: NSObject, NSCoding {
    public static let kBeachSeasonCategory: String = "beach"
    public static let kSkiSeasonCategory: String = "ski"
    public static let kNoSeasonCategory: String = "noSeason"

    public let startDate: Date
    public let endDate: Date
    public let category: String

    internal init(proto: PBLocation.SeasonDate, category: String) throws {
        guard let startDate = HDKDateUtil.seasonDate(proto.from) else {
            throw HDKDateError.incorrectFormat(dateString: proto.from)
        }
        guard let endDate = HDKDateUtil.seasonDate(proto.to) else {
            throw HDKDateError.incorrectFormat(dateString: proto.to)
        }
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
    }

    public init(startDate: Date, endDate: Date, category: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        super.init()
    }

    public init?(coder aDecoder: NSCoder) {

        guard let category = aDecoder.decodeObject(forKey: "category") as? String,
              let startDate = aDecoder.decodeObject(forKey: "startDate") as? Date,
              let endDate = aDecoder.decodeObject(forKey: "endDate") as? Date else { return nil }

        self.category = category
        self.startDate = startDate
        self.endDate = endDate

        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(category, forKey: "category")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
    }

    public func contains(checkIn: Date, orCheckOut checkOut: Date) -> Bool {
        return HDKDateUtil.isDate(checkIn, between: startDate, and: endDate) ||
            HDKDateUtil.isDate(checkOut, between: startDate, and: endDate)
    }

    public override var debugDescription: String {
        return "\(category), \(startDate) - \(endDate)"
    }
}
