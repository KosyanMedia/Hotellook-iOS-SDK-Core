public final class HDKTripTypeDistribution: NSObject, NSCoding {
    public let percentage: Int
    public let type: String

    public init(type: String, percentage: Int) {
        self.percentage = percentage
        self.type = type
    }

    public init?(coder aDecoder: NSCoder) {
        guard let type = aDecoder.decodeObject(forKey: "type") as? String else {
            return nil
        }

        self.type = type
        percentage = aDecoder.decodeInteger(forKey: "percentage")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(percentage, forKey: "percentage")
        aCoder.encode(type, forKey: "type")
    }

}
