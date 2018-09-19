@objcMembers
public final class HDKLanguageDistribution: NSObject, NSCoding {
    public let lang: String
    public let percentage: Int

    public init(lang: String, percentage: Int) {
        self.lang = lang
        self.percentage = percentage
    }

    public init?(coder aDecoder: NSCoder) {
        guard let lang = aDecoder.decodeObject(forKey: "lang") as? String else {
            return nil
        }

        self.lang = lang
        percentage = aDecoder.decodeInteger(forKey: "percentage")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lang, forKey: "lang")
        aCoder.encode(percentage, forKey: "percentage")
    }
}
